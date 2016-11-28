<?php
/**
 * @file
 * Class structure and definition for SimpleDataTableViewConfig
 */

class SimpleDataTableViewConfig {

    public $headerTitle;
    public $headerSubTitle;
    public $tableColumns;
    public $sortColumn;

    /**
     * @param $viewConfig
     */
    function __construct($viewConfig) {
        $this->headerTitle = $viewConfig->headerTitle;
        $this->headerSubTitle = $viewConfig->headerSubTitle;
        $this->tableColumns = array();
        foreach($viewConfig->tableColumns as $tableColumn) {
            $this->tableColumns[] = new SimpleDataTableColumnViewConfig($tableColumn);
        }
        $sortColumn = explode(" ",$viewConfig->orderBy);
        $this->sortColumn = $sortColumn[0];
    }
} 