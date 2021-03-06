<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
    <spring:message code="label_buy" var="labelBuy"/>
    <spring:message code="label_price" var="labelPrice"/>
    <spring:message code="label_checkout" var="labelCheckout"/>
    <spring:message code="label_add_to_basket" var="labelBasket"/>
    <spring:message code="label_choose_props" var="labelChooseProps"/>
    <spring:message code="label_color" var="labelColor"/>
    <spring:message code="label_size" var="labelSize"/>
    <spring:message code="label_amount" var="labelAmount"/>
    <spring:message code="label_back" var="labelBack"/>
    <spring:message code="label_checkout" var="labelWelcome"/>
    <spring:message code="label_verify_email" var="labelVerifyEmail"/>

    <spring:url value="/shopping/cart/" var="backUrl"/>
    <spring:url value="/customer/account/update/" var="profileUrl"/>
    <spring:url value="/commodity" var="showCommodityUrl"/>

<script src="https://www.paypal.com/sdk/js?client-id=AZLBDto98XnkWuOsGr78XH78ohzsHneaQY9vzVdWu9w5xSKRhv1HQl2KSCBvtIDoEEQpXzLcCvJ8d9BG&currency=USD"></script>

<script type="text/javascript">
const shoppingCartId = ${ShoppingCartCookie};
const showCommodityUrl = '${showCommodityUrl}';
const orderId = '${orderId}';
const customerId = '${customer.id}';
var shoppingCartObj;

function paymentConfirm(json){
    $('#order-id').empty();
    $('#order-id').append(orderId);
    showPaymentConfirmed();
    $('#spinner').hide();
    showToast("Order #" + orderId +" successfully paid" );
}

function paymentConfirmError(json) {
    $('#error-container').hide();
    $('#payment-confirmed').hide();
    $('#shopping-cart').hide();
    $('#payment-info').hide();
    showErrorFromJson(json);
    $('#spinner').hide();
}

function showPaymentContent() {
    $('#error-container').hide();
    $('#payment-confirmed').hide();
    $('#order-cancel-btn').show();
    $('#shopping-cart').show();
    $('#payment-info').show();
}

function showPaymentConfirmed() {
    $('#shopping-cart').hide();
    $('#payment-info').hide();
    $('#error-container').hide();
    $('#order-cancel-btn').hide();
    $('#payment-confirmed').show();
}

function showPaymentCanceled() {
    $('#error-container').hide();
    $('#payment-confirmed').hide();
    $('#order-cancel-btn').hide();
    $('#shopping-cart').hide();
    $('#payment-info').hide();
}

function loadCartSuccess(json) {
    shoppingCartObj = json;
    if(shoppingCartObj.itemsAmount>0) {
        showShoppingCartMeta(shoppingCartObj);
        showToast("Please checkout for selected items!");
    }else{
        showToast("Shopping cart is empty");
    }
}

function cancelSuccess(json) {
    window.location.href = "${backUrl}";
}

function cancelError(json) {
    showToast("Can not cancel the Order #"+orderId);
}

function cancelOrderAction() {
    cancelCustomerOrder(orderId, customerId, cancelSuccess, cancelError);
}

$(document).ready(function () {

    showPaymentContent();
    getShoppingCart(shoppingCartId, loadCartSuccess);

    activateTab('tab-shopping-cart');

    var btnCancel = document.querySelector('#order-cancel-btn');
      btnCancel.addEventListener('click', function() {
        cancelOrderAction();
      } );

    paypal.Buttons({
                // Set up the transaction
                createOrder: function(data, actions) {
                    var price = getAmountItemsInShoppingCart(shoppingCartObj).price;
                    price = 1.0; //test
                    return actions.order.create({
                        purchase_units: [
                        {
                            amount: {
                                value: ''+ price +'',
                                currency_code: 'USD'
                            },
                            description: "titsonfire.store Payment for order #" + orderId + " "
                        }
                        ]
                    });
                },

                // Finalize the transaction
                onApprove: function(data, actions) {
                    console.log( "DATA" );
                    console.log( data );
                    return actions.order.capture().then(function(details) {
                        // Show a success message to the buyer
                        $('#spinner').show();
                        console.log(details);
                        console.log("Order id = " + data.orderID);
                        console.log("Inner orderId " + orderId);
                        showToast('Transaction '+ orderId +' completed by ' + details.payer.name.given_name + '!');
                        confirmPaymentOrder(orderId, data.orderID, "Paypal", paymentConfirm, paymentConfirmError);
                        //confirmOrder
                    });
                }
            }).render('#paypal-button-container');

});
</script>
<div class="mdl-grid portfolio-max-width">
     <div class="mdl-cell mdl-cell--12-col mdl-card mdl-shadow--4dp">

            <div class="mdl-card__title">
                <h2 class="mdl-card__title-text commodity-name">${labelWelcome}</b></h2>
            </div>
            <div class="mdl-card__media" style="background-color:white" ></div>
            <div class="mdl-card__supporting-text"><span>Comment for page</span></div>
            <div class="mdl-grid portfolio-copy">
                <div id="error-container" class="mdl-cell mdl-cell--12-col">
                    <h4>Error</h4>
                    <p id="error-message"></p>
                </div>
                <div class="mdl-cell mdl-cell--12-col">
                Shopping Cart Subtotal (<div class="data-holder" id="total-items">${shoppingCart.itemsAmount}</div> items):&nbsp;<div class="data-holder" id="total-cart-price">${shoppingCart.totalPrice} </div>
                </div>

                <div id="delivery-info" class="mdl-cell mdl-cell--6-col">
                <b>Delivery Address:</b><br/>
                ${customer.email}<br/>
                ${customer.fullName}<br/>
                ${customer.country}, ${customer.postcode}, ${customer.city}, ${customer.address}
                </div>

                <button id="order-cancel-btn" class="mdl-cell mdl-cell--6-col mdl-cell--6-col-phone mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--accent">
                     Back to Cart
                </button>

                <div id="payment-info" class="mdl-cell mdl-cell--6-col">
                    <div class="mdl-grid">
                        <div class="mdl-cell mdl-cell--2-col">&nbsp;</div>
                        <div class="mdl-cell mdl-cell--8-col">
                            <div id="paypal-button-container"></div>
                        </div>
                        <div class="mdl-cell mdl-cell--2-col">&nbsp;</div>

                    </div>
                </div>

                <div id="payment-confirmed" class="mdl-cell mdl-cell--6-col">
                    <div class="mdl-grid">
                        <div class="mdl-cell mdl-cell--2-col">&nbsp;</div>
                        <div class="mdl-cell mdl-cell--8-col">
                        Thank you for your purchase!<br/>
                        Order #<b id="order-id"></b> confirmed<br/>
                        You can track the order status in your <a href="${profileUrl}">profile</a>:
                        You will receive order status updates by email.<br/>
                        Estimated time of dispatch: 1-3 days
                        </div>
                        <div class="mdl-cell mdl-cell--2-col">&nbsp;</div>
                    </div>
                </div>

            </div>


    </div>
</div>