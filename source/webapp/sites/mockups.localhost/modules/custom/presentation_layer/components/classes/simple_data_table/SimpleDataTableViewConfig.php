<?php
/**
 * @file
 * Class structure and definition for SimpleDataTableViewConfig
 */

class SimpleDataTableViewConfig {

    public $component;
    public $headerTitle;
    public $headerSubTitle;
    public $tableColumns;
    public $sortColumn;
    public $defaultParameters;
    public $defaultLimit;
    public $orderBy;

    /**
     * @param $viewConfig
     */
    function __construct($viewConfig) {
        $this->headerTitle = $viewConfig->headerTitle;
        $this->headerSubTitle = $viewConfig->headerSubTitle;
        $this->component = $viewConfig->component;
        $this->defaultParameters = $viewConfig->defaultParameters;
        $this->defaultLimit = $viewConfig->defaultLimit;
        $this->orderBy = $viewConfig->orderBy;
        $this->tableColumns = array();
        foreach($viewConfig->tableColumns as $tableColumn) {
            $this->tableColumns[] = new SimpleDataTableColumnViewConfig($tableColumn);
        }
        $sortColumn = explode(" ",$this->orderBy);
        $this->sortColumn = $sortColumn[0];
    }
} 