<?php
/**
 * @file
 * Class structure and definition for SimpleDataTableColumnViewConfig
 */

class SimpleDataTableColumnViewConfig {

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