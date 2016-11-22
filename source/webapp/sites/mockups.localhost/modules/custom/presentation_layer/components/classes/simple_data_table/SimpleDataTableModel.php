<?php
/**
 * @file
 * Class structure and definition for SimpleDataTableModel
 */

class SimpleDataTableModel {

    public $data;
    public $count;

    function __construct($data,$count) {
        $this->data = $data;
        $this->count = $count;
    }
} 