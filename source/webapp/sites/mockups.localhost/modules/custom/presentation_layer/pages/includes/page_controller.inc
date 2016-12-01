<?php

function _page_controller_get_mwbe_spending_data_table($component) {

    $output = ComponentUtil::DisplaySimpleDataTableComponent("mwbe_spending_landing",$component,null,null);
    return $output;

}

