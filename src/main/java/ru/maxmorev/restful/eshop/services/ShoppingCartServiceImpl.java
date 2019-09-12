package ru.maxmorev.restful.eshop.services;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.maxmorev.restful.eshop.entities.CommodityBranch;
import ru.maxmorev.restful.eshop.entities.ShoppingCart;
import ru.maxmorev.restful.eshop.entities.ShoppingCartSet;
import ru.maxmorev.restful.eshop.repos.ShoppingCartRepository;
import ru.maxmorev.restful.eshop.repos.ShoppingCartSetRepository;

import java.util.HashSet;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;

@Service("shoppingCartService")
@Transactional
public class ShoppingCartServiceImpl implements ShoppingCartService {

    private static final Logger logger = LoggerFactory.getLogger(ShoppingCartServiceImpl.class);

    private ShoppingCartRepository shoppingCartRepository;
    private ShoppingCartSetRepository shoppingCartSetRepository;

    private CommodityService commodityService;

    @Autowired
    public void setCommodityService(CommodityService commodityService) {
        this.commodityService = commodityService;
    }

    @Autowired
    public void setShoppingCartRepository(ShoppingCartRepository shoppingCartRepository) {
        this.shoppingCartRepository = shoppingCartRepository;
    }
    @Autowired
    public void setShoppingCartSetRepository(ShoppingCartSetRepository shoppingCartSetRepository) {
        this.shoppingCartSetRepository = shoppingCartSetRepository;
    }

    @Override
    public ShoppingCart createEmptyShoppingCart() {
        ShoppingCart newCart = new ShoppingCart();
        shoppingCartRepository.save(newCart);
        return newCart;
    }

    @Override
    @Transactional(readOnly = true)
    public ShoppingCart findShoppingCartById(Long id) {
        Optional<ShoppingCart> cart = shoppingCartRepository.findById(id);
        if(cart.isPresent()){
            return cart.get();
        }
        return null;
    }

    private void isValidShoppingCartSet(ShoppingCartSet shoppingCartSet){
        if(Objects.isNull(shoppingCartSet)){
            throw new IllegalArgumentException("Illegal argument: ShoppingCartSet is null");
        }
        if(Objects.isNull(shoppingCartSet.getAmount()) || shoppingCartSet.getAmount()<=0){
            throw new IllegalArgumentException("Illegal argument amount="+shoppingCartSet.getAmount());
        }

        if(Objects.isNull(shoppingCartSet.getBranch())){
            throw new IllegalArgumentException("Illegal argument branch="+shoppingCartSet.getBranch());
        }

        if(Objects.isNull(shoppingCartSet.getShoppingCart())){
            throw new IllegalArgumentException("Illegal argument shoppingCart="+shoppingCartSet.getShoppingCart());
        }
    }

    //@Override
    protected ShoppingCart addToShoppingCartSet(ShoppingCartSet shoppingCartSet, Integer amount) {

        isValidShoppingCartSet(shoppingCartSet);
        logger.info("======================================");
        logger.info("addToShoppingCartSet : " + shoppingCartSet);
        CommodityBranch branch = shoppingCartSet.getBranch();
        ShoppingCart cart = shoppingCartSet.getShoppingCart();

        if(Objects.isNull(shoppingCartSet.getId())){
            //adding new set
            if( shoppingCartSet.getAmount() > branch.getAmount() ){
                return cart;
            }
            cart.getShoppingSet().add(shoppingCartSet);
        }else{
            if( shoppingCartSet.getAmount()+amount > branch.getAmount() ){
                return cart;
                //throw new IllegalArgumentException( "amount =" + shoppingCartSet.getAmount() +" Must be less than or equal to the branch.amount=" + branch.getAmount() );
            }
            shoppingCartSet.setAmount(shoppingCartSet.getAmount() + amount);
        }

        shoppingCartRepository.save(cart);
        return cart;
    }

    @Override
    public ShoppingCart addBranchToShoppingCart(Long branchId, Integer amount, Long shoppingCartId) {
        if(branchId==null) throw new IllegalArgumentException("branchId can not be null");
        if(amount==null) throw new IllegalArgumentException("amount can not be null");
        if(shoppingCartId==null) throw new IllegalArgumentException("shoppingCartId can not be null");

        CommodityBranch branch = commodityService.findBranchById(branchId);
        ShoppingCart shoppingCart = this.findShoppingCartById(shoppingCartId);
        ShoppingCartSet shoppingCartSet = this.findByBranchAndShoppingCart(branch, shoppingCart);
        if(Objects.isNull(shoppingCartSet)){
            shoppingCartSet = new ShoppingCartSet();
            shoppingCartSet.setAmount(amount);
            shoppingCartSet.setBranch(branch);
            shoppingCartSet.setShoppingCart(shoppingCart);
        }
        return this.addToShoppingCartSet(shoppingCartSet, amount);
    }

    @Override
    public ShoppingCart removeFromShoppingCartSet(ShoppingCartSet shoppingCartSet, Integer amount) {
        isValidShoppingCartSet(shoppingCartSet);
        logger.info("======================================");
        logger.info("removeFromShoppingCartSet : "+ shoppingCartSet);
        CommodityBranch branch = shoppingCartSet.getBranch();
        ShoppingCart cart = shoppingCartSet.getShoppingCart();

        //Optional<ShoppingCartSet> setExist = shoppingCartSetRepository.findByBranchAndShoppingCart(branch, cart);
        if (shoppingCartSet.getAmount() - amount <=0) {
            //remove set from cart
            cart.getShoppingSet().remove(shoppingCartSet);
        }else{
            shoppingCartSet.setAmount(shoppingCartSet.getAmount() - amount);
        }
        //update set cart
        shoppingCartRepository.save(cart);
        return cart;
    }

    @Override
    @Transactional(readOnly = true)
    public ShoppingCartSet findByBranchAndShoppingCart(CommodityBranch branch, ShoppingCart cart) {
        Optional<ShoppingCartSet> oSCS = shoppingCartSetRepository.findByBranchAndShoppingCart(branch, cart);
        if(oSCS.isPresent()){
            return  oSCS.get();
        }else {
            return null;
        }
    }

    @Override

    public ShoppingCart update(ShoppingCart sc) {
        return shoppingCartRepository.save(sc);
    }

    @Override
    public ShoppingCart mergeFromTo(ShoppingCart from, ShoppingCart to) {
        if(from!=null && to!=null && !Objects.equals(from, to)) {
            for (ShoppingCartSet set : from.getShoppingSet()) {
                try {
                    this.addBranchToShoppingCart(set.getBranch().getId(), set.getAmount(), to.getId());
                } catch (Exception ex) {
                    logger.error("Error in merge: " + ex);
                }
            }
            shoppingCartRepository.delete(from);
        }
        return to;
    }

    @Override
    public ShoppingCart checkAvailability(ShoppingCart sc) {
        Set<ShoppingCartSet> removeFromCart = new HashSet<>();
        for(ShoppingCartSet set: sc.getShoppingSet()){
            if(set.getBranch().getAmount()==0){
                //remove set from shopping cart
                removeFromCart.add(set);
            }else {
                if (set.getBranch().getAmount() < set.getAmount()) {
                    set.setAmount(set.getBranch().getAmount());
                }
            }
        }
        for(ShoppingCartSet remove: removeFromCart){
            sc.getShoppingSet().remove(remove);
        }
        return shoppingCartRepository.save(sc);
    }
}
