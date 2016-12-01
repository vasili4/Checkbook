<?php
/**
 * @file
 * Class to access/render custom components
 */

class ComponentUtil {

    static function DisplaySimpleDataTableComponent($config,$component,$parameters,$limit) {

        $viewModel = self::loadViewModel($config,$component,$parameters,$limit);
        $viewModel->model = self::formatModelHtml($viewModel->model,$viewModel->viewConfig);

        return theme('simple_data_table',array('viewModel'=>$viewModel));
    }

    /**
     * Function will read the configuration file and return the viewModel
     *
     * @param $config
     * @param $component
     * @param $parameters
     * @param $limit
     * @return SimpleDataTableViewModel
     */
    static function loadViewModel($config,$component,$parameters,$limit) {

        $config = self::loadConfig($config);
        $viewConfig = $config->views->$component;
        $viewConfig->component = $component;
        $orderBy = $viewConfig->orderBy;

        //use default limit and parameters
        $limit = isset($limit) ? $limit : $viewConfig->defaultLimit;
        foreach($viewConfig->defaultParameters as $key=>$value) {
            $parameters[$key] = $value;
        }
        $viewModel = new SimpleDataTableViewModel($viewConfig,$parameters,$limit,$orderBy);

        return $viewModel;
    }


    /**
     * Function will format the data for html display
     *
     * @param $model
     * @param $viewConfig
     * @return mixed
     */
    static function formatModelHtml($model, $viewConfig) {
        $tooltipColumns = array_filter($viewConfig->tableColumns,
            function($value) {
                return isset($value->tooltip);
            });
        if(count($tooltipColumns) > 0) {
            foreach($model->data as $key => $val) {
                foreach($tooltipColumns as $column) {
                    $model->data[$key][$column->column] = FormattingUtilities::getTooltip($model->data[$key][$column->column], $column->tooltip);
                }
            }
        }
        return $model;
    }


    /**
     * Function to load the configuration file for the component
     * @param $name
     * @return mixed|stdClass
     */
    static function loadConfig($name){
        $config =  new stdClass();
        $files = file_scan_directory( drupal_get_path('module','component_controller') , '/^'.$name.'\.json$/');
        if(count($files) > 0){
            $file_names = array_keys($files);
            $json = file_get_contents($file_names[0]);
            $config = json_decode($json);
        }
        return $config;
    }

} 