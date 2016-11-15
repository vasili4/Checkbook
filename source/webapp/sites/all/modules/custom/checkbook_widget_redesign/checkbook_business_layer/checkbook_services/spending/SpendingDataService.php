<?php
/**
 * Created by PhpStorm.
 * User: atorkelson
 * Date: 2/19/16
 * Time: 4:38 PM
 */

class SpendingDataService extends AbstractDataService {

    const sqlConfigPath = "spending/spending";

    function __construct() {
        parent::__construct(self::sqlConfigPath);
    }

    public function GetChecks($parameters, $limit = null, $orderBy = null) {
        return $this->getData($parameters, $limit, $orderBy, "GetChecks");
    }

    public function GetCountChecks($parameters) {
        return $this->getCountData($parameters, "GetChecks");
    }
}