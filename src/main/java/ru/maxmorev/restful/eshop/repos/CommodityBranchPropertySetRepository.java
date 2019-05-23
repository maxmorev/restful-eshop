package ru.maxmorev.restful.eshop.repos;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import ru.maxmorev.restful.eshop.entities.CommodityBranchAttributeSet;

@Repository
public interface CommodityBranchPropertySetRepository extends CrudRepository<CommodityBranchAttributeSet, Long> {
}
