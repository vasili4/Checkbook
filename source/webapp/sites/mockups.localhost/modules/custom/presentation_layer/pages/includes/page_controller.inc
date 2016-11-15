<?php

class DataTableViewModel {

    private $serviceName;
    private $dataFunction;
    private $countFunction;

    public $viewConfig;
    public $model;

    function __construct($viewConfig,$parameters,$limit,$orderBy) {

        $this->serviceName = $viewConfig->serviceName;
        $this->dataFunction = $viewConfig->dataFunction;
        $this->countFunction = $viewConfig->countFunction;

        $this->viewConfig = new DataTableViewConfig($viewConfig);
        $this->_initializeModel($parameters,$limit,$orderBy);
    }

    private function _initializeModel($parameters,$limit,$orderBy) {

        $serviceName = $this->serviceName;
        $countFunction = $this->countFunction;
        $dataFunction = $this->dataFunction;

        $service = new $serviceName();
        $count = $service->$countFunction($parameters);
        $data = $service->$dataFunction($parameters, $limit, $orderBy);

        $this->model = new DataTableModel($data,$count);
    }
}


class DataTableViewConfig {

    public $headerTitle;
    public $headerSubTitle;
    public $tableColumns;

    /**
     * @param $viewConfig
     */
    function __construct($viewConfig) {
        $this->headerTitle = $viewConfig->headerTitle;
        $this->headerSubTitle = $viewConfig->headerSubTitle;
        $this->tableColumns = array();
        foreach($viewConfig->tableColumns as $tableColumn) {
            $this->tableColumns[] = new DataTableColumnViewConfig($tableColumn);
        }
    }
}

class DataTableColumnViewConfig {

    public $label;
    public $column;
    public $format;
    public $tooltip;

    function __construct($tableColumn) {
        $this->label = $tableColumn->label;
        $this->column = $tableColumn->column;
        $this->format = $tableColumn->format;
        $this->tooltip = $tableColumn->tooltip;
    }
}

class DataTableModel {

    public $data;
    public $count;

    function __construct($data,$count) {
        $this->data = $data;
        $this->count = $count;
    }
}


function _page_controller_get_spending_landing() {

    $config = _page_controller_load_config('mwbe_spending_landing');

    $parameters = array('year'=>118,'mwbe'=>'(2,3,4,5,9)');
    $limit = 5;

    // Top Checks
    $viewConfig = $config->views->topChecks;
    $orderBy = $viewConfig->orderBy;
    $viewModel = new DataTableViewModel($viewConfig,$parameters,$limit,$orderBy);

    return $viewModel;


    // Top Agencies
}



function _page_controller_load_config($name){
    $config =  new stdClass();
    $files = file_scan_directory( drupal_get_path('module','page_controller') , '/^'.$name.'\.json$/');
    if(count($files) > 0){
        $file_names = array_keys($files);
        $json = file_get_contents($file_names[0]);
        $config = json_decode($json);
    }
    return $config;
}