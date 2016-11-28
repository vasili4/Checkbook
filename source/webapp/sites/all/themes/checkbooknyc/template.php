<?php

/**
 * Add body classes if certain regions have content.
 */
function checkbooknyc_preprocess_html(&$variables) {
  if (!empty($variables['page']['featured'])) {
    $variables['classes_array'][] = 'featured';
  }

  if (!empty($variables['page']['triptych_first'])
    || !empty($variables['page']['triptych_middle'])
    || !empty($variables['page']['triptych_last'])) {
    $variables['classes_array'][] = 'triptych';
  }

  if (!empty($variables['page']['footer_firstcolumn'])
    || !empty($variables['page']['footer_secondcolumn'])
    || !empty($variables['page']['footer_thirdcolumn'])
    || !empty($variables['page']['footer_fourthcolumn'])) {
    $variables['classes_array'][] = 'footer-columns';
  }

    drupal_add_js('https://d3js.org/d3.v3.min.js', 'external');
}

/**
 * Override or insert variables into the page template for HTML output.
 */
function checkbooknyc_process_html(&$variables) {
  // Hook into color.module.
  if (module_exists('color')) {
    _color_html_alter($variables);
  }
}

/**
 * Registers overrides for various functions.
 *
 * In this case, overrides three user functions
 */
function checkbooknyc_theme() {
    $items = array();

    $items['user_login'] = array(
        'render element' => 'form',
        'path' => drupal_get_path('theme', 'checkbooknyc') . '/templates',
        'template' => 'user-login',
        'preprocess functions' => array(
            'checkbooknyc_preprocess_user_login'
        ),
    );
    return $items;
}

function checkbooknyc_preprocess_user_login(&$variables) {
    $variables['intro_text'] = t('Administrator Login');

}
