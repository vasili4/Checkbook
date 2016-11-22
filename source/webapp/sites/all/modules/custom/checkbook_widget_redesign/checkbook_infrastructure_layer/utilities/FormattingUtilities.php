<?php

/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
class FormattingUtilities {

    /**
     * formats the number for display purposes, eg:1000000 will be displayed as 1M
     * @param int,float $number
     * @param int $decimal_digits
     * @param string $prefix
     * @param string $suffix
     * @return string formattedNumber
     */
    static function formatNumber($number, $decimal_digits = 0, $prefix = '', $suffix = '') {
        $thousands = 1000;
        $millions = $thousands * 1000;
        $billions = $millions * 1000;
        $trillions = $billions * 1000;
        $formattedNumber = '';
        if($number < 0) {
            $formattedNumber =  '-';
        }

        if(abs($number) >= $trillions) {
            $formattedNumber = $formattedNumber . $prefix . number_format((abs($number)/$trillions), $decimal_digits, '.', ',') . 'T' . $suffix;
        }
        else if(abs($number) >= $billions) {
            $formattedNumber = $formattedNumber . $prefix . number_format((abs($number)/$billions), $decimal_digits, '.', ',') . 'B' . $suffix;
        }
        else if(abs($number) >= $millions) {
            $formattedNumber = $formattedNumber . $prefix . number_format((abs($number)/$millions), $decimal_digits, '.', ',') . 'M' . $suffix;
        }
        else if(abs($number) >= $thousands) {
            $formattedNumber = $formattedNumber . $prefix . number_format((abs($number)/$thousands), $decimal_digits, '.', ',') . 'K' . $suffix;
        }
        else {
            $formattedNumber = $formattedNumber . $prefix . number_format(abs($number), $decimal_digits, '.', ',') . $suffix;
        }
        return $formattedNumber;
    }

    /**
     * formats the date for display purposes, eg:2016-01-08 will be displayed as 01/08/2016
     * @param $date
     * @return string
     */
    static function formatDate($date){
        $raw_date = new DateTime($date);
        $formattedDate = $raw_date->format('m/d/Y');
        return $formattedDate;
    }


    /**
     * Generates the replacement text for a title used as tooltip
     * @param $text
     * @param int $length
     * @param int $no_of_lines
     * @return string
     */
    static function getTooltip($text, $length = 20, $no_of_lines = 2){
        return self::breakText(html_entity_decode($text,ENT_QUOTES), $length, $no_of_lines);
    }

    /**
     * Adds breaks to text for wrapping
     * @param $text
     * @param int $length
     * @param int $no_of_lines
     * @return string
     */
    static function breakText($text, $length = 20, $no_of_lines = 2){
        $text_array = explode(" ",$text);
        $offset = 0;
        $remaining_original = $remaining = ($length%2 == 0) ? ($length/$no_of_lines) : (round($length/$no_of_lines)-1);
        $first_line = true;

        $index= 0 ;

        if(strlen($text_array[0]) >= 2 * $remaining_original ){
            return "<span title='" . htmlentities($text,ENT_QUOTES) . "'>". substr(htmlentities($text), 0, $length -3 ) . "...</span>";
        }
        else{
            foreach($text_array as $key=>$value){
                if($first_line){
                    if(strlen($value) >= $remaining && $index ==0){
                        $first_line = false;
                        $second_line = true;
                        $remaining = 2* $remaining_original -  strlen($value) -1;
                        $offset = strlen($value)+1;
                    }
                    else{
                        $remaining = $remaining - (strlen($value)+1);
                        if($remaining <= 0){
                            $first_line = false;
                            $second_line = true;
                            $remaining = $remaining_original;
                        }
                        else{
                            $offset += strlen($value)+1;
                        }
                    }
                }
                if($second_line){
                    $prev_remaining = $remaining;
                    $remaining = $remaining - (strlen($value)+1)  ;
                    if($remaining >= 0){
                        $offset = $offset + strlen($value)+1;
                    }else{
                        $offset = $offset+( $prev_remaining - 3  );
                        $second_line = false;
                    }
                }
                $index +=1;
            }

            if($offset < strlen($text) )
                return "<span title='" . htmlentities($text,ENT_QUOTES) . "'>". htmlentities(substr($text, 0, $offset )) . "...</span>";
            else
                return "<span title='" . htmlentities($text,ENT_QUOTES) . "'>". htmlentities(substr($text, 0, $offset )) . "</span>";
        }


    }
}

