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

    public function GetAgencies($parameters, $limit = null, $orderBy = null) {
        return $this->getData($parameters, $limit, $orderBy, "GetAgencies");
    }
    public function GetCountAgencies($parameters) {
        return $this->getCountData($parameters, "GetAgencies");
    }

    public function GetExpenseCategories($parameters, $limit = null, $orderBy = null) {
        return $this->getData($parameters, $limit, $orderBy, "GetExpenseCategories");
    }
    public function GetCountExpenseCategories($parameters) {
        return $this->getCountData($parameters, "GetExpenseCategories");
    }

    public function GetPrimeVendors($parameters, $limit = null, $orderBy = null) {
        return $this->getData($parameters, $limit, $orderBy, "GetPrimeVendors");
    }
    public function GetCountPrimeVendors($parameters) {
        return $this->getCountData($parameters, "GetPrimeVendors");
    }

    public function GetSubVendors($parameters, $limit = null, $orderBy = null) {
        return $this->getData($parameters, $limit, $orderBy, "GetSubVendors");
    }
    public function GetCountSubVendors($parameters) {
        return $this->getCountData($parameters, "GetSubVendors");
    }

    public function GetContracts($parameters, $limit = null, $orderBy = null) {
        return $this->getData($parameters, $limit, $orderBy, "GetContracts");
    }
    public function GetCountContracts($parameters) {
        return $this->getCountData($parameters, "GetContracts");
    }

    public function GetSpendingByIndustries($parameters, $limit = null, $orderBy = null) {
        return $this->getData($parameters, $limit, $orderBy, "GetSpendingByIndustries");
    }
    public function GetCountSpendingByIndustries($parameters) {
        return $this->getCountData($parameters, "GetSpendingByIndustries");
    }
}