<?php
/**
 * Created by PhpStorm.
 * User: atorkelson
 * Date: 12/2/16
 * Time: 2:13 PM
 */

class MockData {

    private static $spending_categories = null;
    private static $domains = null;
    private static $sub_domains = null;
    private static $agencies = null;



    static function SpendingByDomains(){

        if(!isset(self::$domains)) {
            $service = new SpendingDataService();
            $parameters = array('year'=>118,'mwbe'=>'(2,3,4,5,9)');
            $values =  array();
            $model = $service->GetSpendingByDomain($parameters);
            foreach($model as $row) {
                $values[] = array(
                    "name" => $row["domain"],
                    "value" => FormattingUtilities::formatNumber($row["total_amount"],2,'$')
                );
            }
            self::$domains = $values;
        }
        return self::$domains;
    }
    static function SpendingByCategories(){

        if(!isset(self::$spending_categories)) {
            $service = new SpendingDataService();
            $parameters = array('year'=>118,'mwbe'=>'(2,3,4,5,9)');
            $values =  array();
            $model = $service->GetSpendingByCategory($parameters);
            foreach($model as $row) {
                $values[] = array(
                    "name" => $row["spending_category"],
                    "value" => FormattingUtilities::formatNumber($row["total_spending_amount"],2,'$')
                );
            }
           self::$spending_categories = $values;
        }
        return self::$spending_categories;
    }

    static function SpendingBySubDomains(){
        if(!isset(self::$sub_domains)) {
            $service = new SpendingDataService();
            $parameters = array('year'=>118,'mwbe'=>'(2,3,4,5,9)');
            $values =  array();
            $model = $service->GetSpendingBySubDomain($parameters);
            foreach($model as $row) {
                $values[] = array(
                    "name" => $row["sub_domain"],
                    "value" => FormattingUtilities::formatNumber($row["total_spending_amount"],2,'$')
                );
            }
            self::$sub_domains = $values;
        }
        return self::$sub_domains;
    }

    static function Agencies(){

    }
}
