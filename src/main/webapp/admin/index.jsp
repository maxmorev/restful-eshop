<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<html>
<head>
    <meta charset="utf-8">

    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <!--<link rel="stylesheet" href="https://code.getmdl.io/1.3.0/material.indigo-pink.min.css">-->
    <link rel="stylesheet" href="../mdl/material.min.css">
    <link rel="stylesheet" href="../styles/application.css">
   <!--
    <script defer src="https://code.getmdl.io/1.3.0/material.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    -->
    <!--local scripts -->
    <link rel="stylesheet" href="../mdl/fonts.css">
    <link rel="stylesheet" href="../mdl/material.min.css">
    <script defer src="../mdl/material.min.js"></script>
    <script src="../mdl/jquery.min.js"></script>
    <!-- commodity css -->
    <style>
    label.input-custom-file input[type=file] {
        display: none;
    }
    .img-parent {
        position: relative;
        border: 1px solid gray;
        width: 200px;
        height: 200px;
    }
    .img-placeholder {
        width: 200px;
        height: 200px;
    }
    .img-upload-spinner {
        position:absolute;
        top:100px;
        left:90px
    }
    .img-upload-btn {
        position:relative;
        top:-45px;
        left:155px
    }
    .mdl-cell {
        min-width:200px;

    }

    .btn-add-commodity{
        position:relative;
        top:10px;
        left:650px;
    }

    .small-form-text {
        width: 130px;
    }
    .attribute-table{
        width: 250px;
    }

    </style>
    <!-- end of commodity css -->
    <script type="text/javascript">

    var URL_SERVICES = "<%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath().equals("")?"":request.getContextPath()%>";
    </script>
    <script src="../scripts/commodity-type.js"></script>


</head>

<body>

<!-- Simple header with scrollable tabs. -->
<div class="mdl-layout mdl-js-layout mdl-layout--fixed-header">
    <header class="mdl-layout__header">
        <div class="mdl-layout__header-row">
            <!-- Title -->
            <span class="mdl-layout-title">Smart eShop</span>
        </div>
        <!-- Tabs -->
        <div class="mdl-layout__tab-bar mdl-js-ripple-effect">
            <a href="#scroll-tab-1" class="mdl-layout__tab is-active">Commodity Types</a>
            <a href="#scroll-tab-2" class="mdl-layout__tab" onclick="loadBranchList();">Commodity</a>

        </div>
    </header>
    <div class="mdl-layout__drawer">
        <span class="mdl-layout-title">Smart eShop</span>
    </div>
    <main class="mdl-layout__content">
        <section class="mdl-layout__tab-panel is-active" id="scroll-tab-1">
            <div class="page-content">
                <!-- Your content goes here -->
                <div class="mdl-grid">
                    <!-- left form -->
                    <!-- Basic Chip for errors -->
                    <div class="mdl-cell mdl-cell--2-col">
                        <!-- Mini FAB button -->
                        <button id="btn-attribute-back" class="mdl-button mdl-js-button mdl-button--fab mdl-button--mini-fab">
                            <i class="material-icons">arrow_back</i>
                        </button>
                    </div>
                    <div class="mdl-cell mdl-cell--8-col">
                        <div id="error-container-1">
                        <span class="mdl-chip" id="error-message-1">
                        <span class="mdl-chip__text" id="error-message-content-1"></span>
                        </span>
                        </div>
                    </div>
                    <div class="mdl-cell mdl-cell--2-col" id="navigation-text"></div>
                    <!-- form create commodityType -->
                </div>
                <div class="mdl-grid">
                    <div class="mdl-cell mdl-cell--2-col">
                        <div id="form-create">
                        <form  action="#">

                            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                <input class="mdl-textfield__input" type="text" id="commodityTypeName">
                                <label class="mdl-textfield__label" for="commodityTypeName">Commodity Type Name...</label>
                            </div>
                            <div class="mdl-textfield mdl-js-textfield">
                                <textarea class="mdl-textfield__input" type="text" rows= "3" id="commodityTypeDesc" ></textarea>
                                <label class="mdl-textfield__label" for="commodityTypeDesc">Description...</label>
                            </div>
                            <br/>
                            <!-- Accent-colored raised button with ripple -->
                            <button id="btn-createtype" class="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--accent"  type="button">
                                Create type
                            </button>
                        </form>
                        </div>
                        <!-- end: form create commodityType -->
                        <!-- form edit commodityType -->
                        <div id="form-edit-type">
                            <form  action="#">
                                <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label is-upgraded is-dirty" data-upgraded=",MaterialTextfield">
                                    <input class="mdl-textfield__input" type="text" id="commodityTypeNameEdit">
                                    <label class="mdl-textfield__label" for="commodityTypeNameEdit">Commodity Type Name...</label>
                                </div>
                                <div class="mdl-textfield mdl-js-textfield  is-upgraded is-dirty" data-upgraded=",MaterialTextfield">
                                    <textarea class="mdl-textfield__input" type="text" rows= "3" id="commodityTypeDescEdit" ></textarea>
                                    <label class="mdl-textfield__label" for="commodityTypeDescEdit">Description...</label>
                                </div>
                                <br/>
                                <!-- Accent-colored raised button with ripple -->
                                <button id="btn-edit-type" class="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--accent"  type="button">
                                    Edit type
                                </button>
                            </form>
                        </div>
                        <!-- end form edit commodityType -->

                    </div>
                    <!-- right content -->
                    <div class="mdl-cell mdl-cell--6-col">
                    <!-- commodityType list -->
                    <div id="type-list">

                        <table  class="mdl-data-table mdl-js-data-table">
                            <thead>
                            <tr>
                                <th class="mdl-data-table__cell--non-numeric">id</th>
                                <th>Name</th>
                                <th>Commodity quantity</th>
                                <th>Delete</th>
                            </tr>
                            </thead>
                            <tbody id="container-types">


                            </tbody>
                        </table>
                       </div>
                    <!-- // end commodityType list -->
                    <!-- properties -->
                    <div id="type-properties">
                            <div ><h6>Create constant attributes of you commodity type</h6>
                                Example:<br/> The wear's attribute name is <b>Size</b> and attribute value for <b>Size</b> is <b>S</b>
                                <br/><b>Measure</b> can be undefined.
                            </div>

                            <div class="mdl-grid">

                                <div  class="mdl-cell mdl-cell--12-col">
                                    Select attribute data type:
                                    <div class="mdl-grid" id="data-type-container">
                                        <div mdl-cell mdl-cell--2-col>
                                            <span class="mdl-list__item-primary-content">String</span>
                                            <span class="mdl-list__item-secondary-action">
                                                <label class="demo-list-radio mdl-radio mdl-js-radio mdl-js-ripple-effect" for="list-option-1">
                                                <input type="radio" id="list-option-1" class="mdl-radio__button" name="dataType" value="String" checked />
                                                </label>
                                            </span>
                                        </div>

                                    </div>
                                </div>

                                <div class="mdl-cell mdl-cell--1-col">

                                    <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                        <input class="mdl-textfield__input" type="text" id="propertyName">
                                        <label class="mdl-textfield__label" for="propertyName">Name...</label>
                                    </div>
                                </div>
                                <div class="mdl-cell mdl-cell--1-col">
                                    <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                        <input class="mdl-textfield__input" type="text" id="attributeValue">
                                        <label class="mdl-textfield__label" for="attributeValue">Value...</label>
                                    </div>
                                </div>
                                <div class="mdl-cell mdl-cell--1-col">
                                    <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                        <input class="mdl-textfield__input" type="text" id="attributeMeasure">
                                        <label class="mdl-textfield__label" for="attributeMeasure">Measure...</label>
                                    </div>
                                </div>
                                <div class="mdl-cell mdl-cell--1-col">
                                    <!-- Colored FAB button with ripple -->
                                    <button id="btn-create-attribute" class="mdl-button mdl-js-button mdl-button--fab mdl-button--mini-fab mdl-button--colored">
                                        <i class="material-icons">add</i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    <!-- // properties -->
                    </div>
                    <div class="mdl-cell mdl-cell--4-col" id="attributes-container">
                        <table  class="mdl-data-table mdl-js-data-table">
                            <thead>
                            <tr>
                                <th class="mdl-data-table__cell--non-numeric">Attribute Name</th>
                                <th class="mdl-data-table__cell--non-numeric">Value</th>
                                <th class="mdl-data-table__cell--non-numeric">Data Type</th>
                                <th class="mdl-data-table__cell--non-numeric">Measure</th>
                                <th class="mdl-data-table__cell--non-numeric">Delete attribute</th>
                            </tr>
                            </thead>
                            <tbody id="container-properties">
                            <td class="mdl-data-table__cell--non-numeric">size</td>
                            <td class="mdl-data-table__cell--non-numeric">S</td>
                            <td class="mdl-data-table__cell--non-numeric">String</td>
                            <td class="mdl-data-table__cell--non-numeric"></td>
                            <td class="mdl-data-table__cell--non-numeric">
                                DELETE
                            </td>

                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </section>
<!-- end of section 1 -->

        <!-- SECTION TAB 2 -->
        <section class="mdl-layout__tab-panel" id="scroll-tab-2">
            <div class="page-content">

                <!-- CREATE COMMODITY -->

                <div id="create-commodity">

                <div class="mdl-grid">

                    <!-- error and back button -->
                    <div class="mdl-cell mdl-cell--2-col">
                        <!-- Mini FAB button -->
                        <button onclick="loadBranchList();" id="btn-createupdate-back" class="mdl-button mdl-js-button mdl-button--fab mdl-button--mini-fab">
                            <i class="material-icons">arrow_back</i>
                        </button>
                    </div>
                    <div class="mdl-cell mdl-cell--8-col">
                        <div id="error-container-2">
                        <span class="mdl-chip" id="error-message-2">
                        <span class="mdl-chip__text" id="error-message-content-2"></span>
                        </span>
                        </div>
                    </div>

                    <div class="mdl-cell mdl-cell--4-col">
                        <!-- image grid -->
                        <div class="mdl-grid">

                            <div class="mdl-cell mdl-cell--4-col">
                                <!-- MDL Spinner Component -->
                                <div class="img-parent">
                                    <img src="../images/placeholder.png" id="img0" class="img-placeholder"/>
                                    <div id="img-spinner-0" class="mdl-spinner mdl-js-spinner is-active img-upload-spinner" ></div>
                                    <div class="header-content imgupload imgupload img-upload-btn" >
                                        <label class="input-custom-file mdl-button mdl-js-button mdl-button--fab mdl-button--mini-fab mdl-button--colored">
                                            <i class="material-icons">add</i>
                                            <input id="file0" type="file" onchange="postFile(0);">
                                        </label>
                                    </div>
                                </div>

                            </div>
                            <div class="mdl-cell mdl-cell--4-col">
                                <div class="img-parent">
                                    <img src="../images/placeholder.png" id="img1" class="img-placeholder"/>
                                    <div id="img-spinner-1" class="mdl-spinner mdl-js-spinner is-active img-upload-spinner" ></div>
                                    <div class="header-content imgupload img-upload-btn">
                                        <label class="input-custom-file mdl-button mdl-js-button mdl-button--fab mdl-button--mini-fab mdl-button--colored">
                                            <i class="material-icons">add</i>
                                            <input id="file1" type="file" onchange="postFile(1);">
                                        </label>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="mdl-grid">

                            <div class="mdl-cell mdl-cell--4-col">
                                <div class="mdl-cell mdl-cell--4-col">
                                    <div class="img-parent">
                                        <img src="../images/placeholder.png" id="img2" class="img-placeholder"/>
                                        <div id="img-spinner-2" class="mdl-spinner mdl-js-spinner is-active img-upload-spinner" ></div>
                                        <div class="header-content imgupload img-upload-btn">
                                            <label class="input-custom-file mdl-button mdl-js-button mdl-button--fab mdl-button--mini-fab mdl-button--colored">
                                                <i class="material-icons">add</i>
                                                <input id="file2" type="file" onchange="postFile(2);">
                                            </label>
                                        </div>
                                    </div>

                                </div>

                            </div>
                            <div class="mdl-cell mdl-cell--4-col">

                                <div class="mdl-cell mdl-cell--4-col">
                                    <div class="img-parent">
                                        <img src="../images/placeholder.png" id="img3" class="img-placeholder"/>
                                        <div id="img-spinner-3" class="mdl-spinner mdl-js-spinner is-active img-upload-spinner" ></div>
                                        <div class="header-content imgupload img-upload-btn">
                                            <label class="input-custom-file mdl-button mdl-js-button mdl-button--fab mdl-button--mini-fab mdl-button--colored">
                                                <i class="material-icons">add</i>
                                                <input id="file3" type="file" onchange="postFile(3);">
                                            </label>
                                        </div>
                                    </div>

                                </div>


                            </div>

                        </div>
                        <!-- //image grid -->

                    </div>

                    <!-- COMMODITY FIELDS -->
                    <div class="mdl-cell mdl-cell--2-col">

                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                            <input class="mdl-textfield__input" type="text" id="commodityName">
                            <label class="mdl-textfield__label" for="commodityName">Commodity Name</label>
                        </div>
                        <div class="mdl-textfield mdl-js-textfield">
                            <textarea class="mdl-textfield__input" type="text" rows= "3" id="commodityShortDesc" ></textarea>
                            <label class="mdl-textfield__label" for="commodityShortDesc">Short Description</label>
                        </div>
                        <div class="mdl-textfield mdl-js-textfield">
                            <textarea class="mdl-textfield__input" type="text" rows= "5" id="commodityOverview" ></textarea>
                            <label class="mdl-textfield__label" for="commodityOverview">Overview</label>
                        </div>
                        <br/>


                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                            <input class="mdl-textfield__input" type="text" pattern="-?[0-9]*([0-9]+)?" id="commodityAmount">
                            <label class="mdl-textfield__label" for="commodityAmount">Amount</label>
                            <span class="mdl-textfield__error">Input is not a number!</span>
                        </div>
                        <!-- Numeric Textfield with Floating Label -->
                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                            <input class="mdl-textfield__input" type="text" pattern="-?[0-9]*(\.[0-9]+)?" id="commodityPrice">
                            <label class="mdl-textfield__label" for="commodityAmount">Price per item</label>
                            <span class="mdl-textfield__error">Input is not a number!</span>
                        </div>


                    </div>

                    <div class="mdl-cell mdl-cell--4-col">


                        <div id="commodity-type-container">
                            <!-- place for checkbox with commodity types -->

                        </div>
                        <br/>

                        <span class="mdl-chip">
                            <span class="mdl-chip__text">Properties:</span>
                        </span>
                        <br/>
                        <div id="attributes-cm-container">
                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label small-form-text">
                            <input class="mdl-textfield__input" type="text" id="property-add-to-cm">
                            <label class="mdl-textfield__label" for="property-add-to-cm">Property...</label>
                        </div>
                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label small-form-text">
                            <input class="mdl-textfield__input" type="text" id="value-add-to-cm">
                            <label class="mdl-textfield__label" for="value-add-to-cm">Value...</label>
                        </div>
                        <button class="mdl-button mdl-js-button mdl-button--fab mdl-button--mini-fab" onclick="addAttributeToCm();">
                            <i class="material-icons">add</i>
                        </button>
                        </div>
                        <table class="mdl-data-table mdl-js-data-table attribute-table">
                            <thead>
                            <tr>
                                <th>Appear</th>
                                <th class="mdl-data-table__cell--non-numeric">Property</th>
                                <th class="mdl-data-table__cell--non-numeric">Value</th>
                                <th class="mdl-data-table__cell--non-numeric">Measure</th>
                            </tr>
                            </thead>
                            <tbody id="commodity-properties">

                            </tbody>
                        </table>
                        <!-- Accent-colored raised button with ripple -->
                        <br/>
                        <button id="btn-add-commodity" onclick="btnClickAddCommodity();" class="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--accent">
                            Add commodity
                        </button>
                        <button id="btn-update-commodity" onclick="btnClickUpdateCommodity();" class="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--accent">
                            Update commodity
                        </button>

                        <div id="test-data">
                        </div>


                    </div>
                    <!-- END: COMMODITY FIELDS -->

                </div>

                </div>

                <!-- END: CREATE COMMODITY -->

                <!-- COMMODITY LIST -->

                <div id="commodities-container">

                        <button onclick="loadCreateCommodityForm();" class="mdl-button mdl-js-button mdl-button--fab mdl-button--mini-fab mdl-button--colored btn-add-commodity">
                            <i class="material-icons">add</i>
                        </button>

                    <div class="mdl-grid">

                        <div class="mdl-cell mdl-cell--8-col">
                            <table class="mdl-data-table mdl-js-data-table">
                                <thead>
                                <tr>
                                    <th class="mdl-data-table__cell--non-numeric">Commodity Name</th>
                                    <th class="mdl-data-table__cell--non-numeric">Type</th>
                                    <th class="mdl-data-table__cell--non-numeric">Properties</th>
                                    <th>Amount</th>
                                    <th>Price</th>
                                    <th>Edit</th>
                                </tr>
                                </thead>
                                <tbody id="commodities">

                                </tbody>
                            </table>
                        </div>
                    </div>



                </div>
                <!-- END: COMMODITY LIST-->

            </div>

        </section>

        <!-- END OF SECTION 2 -->
        <!-- Toast place -->

        <div id="demo-toast-example" class="mdl-js-snackbar mdl-snackbar">
            <div class="mdl-snackbar__text"></div>
            <button class="mdl-snackbar__action" type="button"></button>
        </div>

        <!-- end Toast place -->

    </main>
</div>



</body>
</html>
