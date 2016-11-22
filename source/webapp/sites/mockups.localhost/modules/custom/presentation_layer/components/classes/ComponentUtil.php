<?php
/**
 * @file
 * Class to access/render custom components
 */

class ComponentUtil {

    static function DisplaySimpleDataTableComponent($config,$component,$parameters,$limit) {

        $viewModel = self::_loadViewModel($config,$component,$parameters,$limit);
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
    private static function _loadViewModel($config,$component,$parameters,$limit) {

        $config = self::_loadConfig($config);
        $viewConfig = $config->views->$component;
        $orderBy = $viewConfig->orderBy;
        $viewModel = new SimpleDataTableViewModel($viewConfig,$parameters,$limit,$orderBy);

        return $viewModel;
    }

    /**
     * Function to load the configuration file for the component
     * @param $name
     * @return mixed|stdClass
     */
    private static function _loadConfig($name){
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