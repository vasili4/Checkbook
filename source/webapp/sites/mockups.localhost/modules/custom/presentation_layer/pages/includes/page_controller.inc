<?php

function _page_controller_get_mwbe_spending_data_table($component) {

    $parameters = array('year'=>118,'mwbe'=>'(2,3,4,5,9)');
    $output = ComponentUtil::DisplaySimpleDataTableComponent("mwbe_spending_landing",$component,$parameters,5);
    return $output;

}