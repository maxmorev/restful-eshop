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

    <spring:url value="/commodity" var="showCommodityUrl"/>

<script type="text/javascript">
const shoppingCartJson = '${shoppingCart}';
const showCommodityUrl = '${showCommodityUrl}';
const customerId = '${customer.id}';
var shoppingCartObj;

$(document).ready(function () {
    if(shoppingCartJson.length>0){
        shoppingCartObj = JSON.parse(shoppingCartJson);
        showShoppingCart(shoppingCartObj);
        showToast("Please pay for selected items!");
    }else{
        showToast("Shopping cart is empty");
        //show message
    }
    activateTab('tab-shopping-cart');


});
</script>

<div class="mdl-grid portfolio-max-width">
     <div class="mdl-cell mdl-cell--12-col mdl-card mdl-shadow--4dp">
        <c:if test="${not empty shoppingCart}">
            <div class="mdl-card__title">
                <h2 class="mdl-card__title-text commodity-name">${labelWelcome}</b></h2>
            </div>
            <div class="mdl-card__media" style="background-color:white" >

            </div>
            <div class="mdl-card__supporting-text">
            <span>Comment for page</span>
            </div>
            <div class="mdl-grid">

                <tiles:insertAttribute name="cart-container"/>

                <div id="payment-info" class="mdl-cell mdl-cell--12-col">
                    <div class="mdl-grid">
                        <div class="mdl-cell mdl-cell--12-col">
                        <h4>
                        Payment transaction start
                        </h4>
                        </div>
                        <div class="mdl-cell mdl-cell--12-col">
                        PayPal form
                        </div>
                    </div>
                </div>

            </div>

        </c:if>
    </div>
</div>
