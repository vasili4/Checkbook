<?php
/**
 * @file
 * Class structure and definition for SimpleDataTableViewModel
 */

class SimpleDataTableViewModel {

    private $serviceName;
    private $dataFunction;
    private $countFunction;

    public $viewConfig;
    public $model;

    function __construct($viewConfig,$parameters,$limit,$orderBy) {

        $this->serviceName = $viewConfig->serviceName;
        $this->dataFunction = $viewConfig->dataFunction;
        $this->countFunction = $viewConfig->countFunction;

        $this->viewConfig = new SimpleDataTableViewConfig($viewConfig);

        $this->_initializeModel($parameters,$limit,$orderBy);
    }

    private function _initializeModel($parameters,$limit,$orderBy) {

        $serviceName = $this->serviceName;
        $countFunction = $this->countFunction;
        $dataFunction = $this->dataFunction;

        $service = new $serviceName();
        $count = null;//$service->$countFunction($parameters);
        $data = $service->$dataFunction($parameters, $limit, $orderBy);

        $this->model = new SimpleDataTableModel($data,$count);
        $this->model = self::_formatData($this->model);
    }

    /**
     * Function will go through all columns in the table_columns config and apply all formatting to the data
     * @param $model
     * @return mixed
     */
    private function _formatData($model) {

        $formatColumns = array_filter($this->viewConfig->tableColumns,
            function($value) {
                return isset($value->format);
            });
        if(count($formatColumns) > 0) {
            foreach($model->data as $key => $val) {
                //formatting
                foreach($formatColumns as $column) {
                    switch($column->format) {
                        case "dollar":
                            $model->data[$key][$column->column] = FormattingUtilities::formatNumber($model->data[$key][$column->column],2,'$');
                            break;
                        case "date":
                            $model->data[$key][$column->column] = FormattingUtilities::formatDate($model->data[$key][$column->column]);
                            break;
                        case "number":
                            $model->data[$key][$column->column] = number_format($model->data[$key][$column->column]);
                            break;
                        case "percent":
                            $model->data[$key][$column->column] = round($model->data[$key][$column->column],2) . '%';
                            break;
                    }
                }
            }
        }
        return $model;
    }
} 