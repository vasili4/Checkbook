<?php

class DataTableViewModel {

    private $serviceName;
    private $dataFunction;
    private $countFunction;

    protected $columnsConfig;
    protected $model;

    function __construct($viewConfig,$parameters,$limit,$orderBy) {

        $this->serviceName = $viewConfig->serviceName;
        $this->dataFunction = $viewConfig->dataFunction;
        $this->countFunction = $viewConfig->countFunction;

        $this->initializeDataTableColumnsViewConfig($viewConfig->tableColumns);
        $this->initializeModel($parameters,$limit,$orderBy);
    }

    function initializeDataTableColumnsViewConfig($tableColumnsConfig) {

        $this->columnsConfig = array();
        foreach($tableColumnsConfig as $tableColumnConfig) {
            $this->columnsConfig[] = new DataTableColumnViewConfig($tableColumnConfig);
        }
    }

    function initializeModel($parameters,$limit,$orderBy) {

        $service = new $this->serviceName();
        $countFunction = $this->countFunction;
        $dataFunction = $this->dataFunction;

        $count = $service->$countFunction($parameters);
        $data = $service->$dataFunction($parameters, $limit, $orderBy);

        $this->model = new DataTableModel($data,$count);
    }
}

class DataTableColumnViewConfig {

    protected $label;
    protected $column;
    protected $format;
    protected $tooltip;

    function __construct($tableColumnConfig) {
        $this->label = $tableColumnConfig->label;
        $this->column = $tableColumnConfig->column;
        $this->format = $tableColumnConfig->format;
        $this->tooltip = $tableColumnConfig->tooltip;
    }
}

class DataTableModel {

    protected $data;
    protected $count;

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