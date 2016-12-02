<?php

function _component_controller_simple_data_table_export($config,$component) {

    $viewModel = ComponentUtil::loadViewModel($config,$component,null,200000);
    $data = $viewModel->model->data;
    $viewConfig = $viewModel->viewConfig;

    $parameters = array();
    foreach($viewConfig->defaultParameters as $key=>$value) {
        $parameters[$key] = $value;
    }

    $output = NULL;

    $i=0;
    foreach($viewConfig->tableColumns as $column) {
        $output .= ($i == 0) ? $column->label : ',"'.$column->label.'"';
        $i++;
    }
    if(is_array($data) && count($data) > 0) {
        $dataRecords = $data;

        foreach($dataRecords as $dataRec){
            $output .= PHP_EOL;
            $i = 0;
            $rowData = NULL;
            foreach($viewConfig->tableColumns as $column) {

                $columnValue = html_entity_decode($dataRec[$column->column], ENT_QUOTES);
                $columnValue = str_replace('"',chr(34).'"',$columnValue);
                $rowData .= ($i == 0) ? ('"'.$columnValue.'"') : (',"'.$columnValue.'"');
                $i++;
            }
            $rowData = str_replace(array("\r\n", "\n", "\r"),'',$rowData);
            $output .= $rowData;
        }
    }

    drupal_add_http_header("Content-Type", "text/csv");
    drupal_add_http_header("Content-Length",strlen($output));
    drupal_add_http_header("Content-Disposition", "attachment; filename=TransactionsData.csv");
    drupal_add_http_header("Pragma", "cache");
    drupal_add_http_header("Expires", "-1");
    echo $output;

}

function _component_controller_mwbe_spending_summary_chart_data($config,$component) {

    $viewModel = ComponentUtil::loadViewModel($config,$component,null,200000);
    $data = $viewModel->model->data;

    $column_map = array(
        "asian_american_spending" => "Asian American",
        "black_american_spending" => "Black American",
        "hispanic_american_spending" => "Hispanic American",
        "women_spending" => "Women");


    $columns = array_keys($column_map);
    $categories = array_values($column_map);

    if(is_array($data) && count($data) > 0) {

        $values = array();
        $offset = 0;
        foreach($data as $row) {

            foreach($categories as $key => $value) {
                $category = $categories[$key];
                $column = $columns[$key];

                $value = str_replace("$","",$row[$column]);
                $value = str_replace("M","",$value);
                $value = str_replace("k","",$value);

                $values[$category][] = array(
                    "key" => $category,  // key = category;
                    "series" => (int)$row['fiscal_year'], // series = fiscal year
                    "x" => $offset, // x = offset
                    "y" => (float)$value // spending data
                );
            }
            $offset++;
        }

        $keys = array();
        foreach($categories as $category) {
            $keys[] = array(
                "key" => $category,
                "values" => $values[$category]
            );
        }
    }

    $data = json_encode($keys);
    log_debug($data);
    echo $data;

}
