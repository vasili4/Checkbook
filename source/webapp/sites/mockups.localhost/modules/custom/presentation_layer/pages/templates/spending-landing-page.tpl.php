
<?php echo(_page_controller_get_top_navigation_menu()); ?>
<div class="landing">
  <div class="landing-filters">
    <div class="landing-head">
        <?php $spendingData = MockData::SpendingByCategories(); ?>
      <span class="page-title">M/WBE total spending <span class="diamond"></span><?php echo($spendingData[0]["value"]); ?></span>
      <span class="page-subtitle">new york city</span>
      <span class="page-breadcrumb">home - domain: spending - m/wbe</span>
    </div>
    <div class="year-filter">
      <span>fiscal year filter: </span>
      <div>
        <div class="selected-year">2016(Jul 1, 2015 - Jun 30, 2016)</div>
        <div class="year-select">
          <div class="year-select-option">2015</div>
          <div class="year-select-option">2014</div>
          <div class="year-select-option">2013</div>
          <div class="year-select-option">2012</div>
        </div>
      </div>
      <!--change to div select element-->
    </div>
  </div>
    <div class="filter">
        <?php $data = MockData::SpendingBySubDomains(); ?>
        <div class="subdomain-filter"> <span class="label">sub domain</span>
            <div class="subdomain"> <span><?php echo($data[0]["value"]); ?></span> <span><?php echo($data[0]["name"]); ?></span> </div>
            <div class="subdomain"> <span><?php echo($data[1]["value"]); ?></span> <span><?php echo($data[1]["name"]); ?></span> </div>
            <div class="subdomain active"> <span><?php echo($data[2]["value"]); ?></span> <span><?php echo($data[2]["name"]); ?></span> </div>
            <div class="subdomain"> <span><?php echo($data[3]["value"]); ?></span> <span><?php echo($data[3]["name"]); ?></span> </div>
            <div class="subdomain"> <span><?php echo($data[4]["value"]); ?></span> <span><?php echo($data[4]["name"]); ?></span> </div>
            <div class="mwbe-filter-button">select filter</div>
        </div>
        <div class="mwbe-filter">
            <div class="mwbe-filter-mwbe">total m/wbe</div>
            <div class="mwbe-filter-asian">asian american</div>
            <div class="mwbe-filter-black">black american</div>
            <div class="mwbe-filter-women">women</div>
            <div class="mwbe-filter-hispanic">hispanic american</div>
        </div>
        <div class="spending-filter"> <span class="label">spending types</span>
            <div class="subdomain active"> <span><?php echo($spendingData[0]["value"]); ?></span> <span><?php echo($spendingData[0]["name"]); ?></span> </div>
            <div class="subdomain"> <span><?php echo($spendingData[1]["value"]); ?></span> <span><?php echo($spendingData[1]["name"]); ?></span> </div>
            <div class="subdomain"> <span><?php echo($spendingData[2]["value"]); ?></span> <span><?php echo($spendingData[2]["name"]); ?></span> </div>
            <div class="subdomain"> <span><?php echo($spendingData[3]["value"]); ?></span> <span><?php echo($spendingData[3]["name"]); ?></span> </div>
            <div class="subdomain"> <span><?php echo($spendingData[4]["value"]); ?></span> <span><?php echo($spendingData[4]["name"]); ?></span> </div>
            <div class="subdomain"> <span><?php echo($spendingData[5]["value"]); ?></span> <span><?php echo($spendingData[5]["name"]); ?></span> </div>
        </div>
    </div>

  <div class="data-visualization">
      <!-- Charts -->
    <div class="zc-container">
      <div class="domain-label">m/wbe spending summary</div>
      <div class="chart-toggle">
        <div class="chart-bar-stacked active"></div>
        <div class="chart-bar"></div>
        <div class="chart-line"></div>
      </div>
      <div id="chart1" class='with-3d-shadow with-transitions active'>
        <svg width="960" height="500"></svg>
      </div>
      <div id="chart2" class='with-3d-shadow with-transitions'>
        <svg width="950" height="500"></svg>
      </div>
    </div>
    <div class="charts-data-tables-container">
        <div class="charts-data-table-container">
            <?php echo(_page_controller_get_mwbe_spending_data_table("mwbeSpendingByYears")); ?>
        </div>
    </div>
     <a class="charts-data-tables-toggle" href="#"></a>
      <!-- Heat Map -->
      <div class="map-section-container">
          <div class="map-container">
              <div class="domain-label">m/wbe certified prime vendors</div>
              <div class="heat-map"></div>
          </div>
          <div class="map-data-tables-container">
              <div class="map-data-table-container">
                  <?php echo(_page_controller_get_mwbe_spending_data_table("mwbeVendorSpendingByZipCodes")); ?>
              </div>
          </div>
          <a class="map-data-tables-toggle" href="#"></a>
      </div>
      <!-- Data Tables -->
      <div class="data-tables-container">
        <div class="data-table-container">
            <?php echo(_page_controller_get_mwbe_spending_data_table("checks")); ?>
        </div>
        <div class="data-table-container-left">
            <?php echo(_page_controller_get_mwbe_spending_data_table("agencies")); ?>
        </div>
        <div class="data-table-container-right">
            <?php echo(_page_controller_get_mwbe_spending_data_table("expenseCategories")); ?>
        </div>
        <div class="data-table-container">
            <?php echo(_page_controller_get_mwbe_spending_data_table("primeVendors")); ?>
        </div>
        <div class="data-table-container">
            <?php echo(_page_controller_get_mwbe_spending_data_table("subVendors")); ?>
        </div>
        <div class="data-table-container">
            <?php echo(_page_controller_get_mwbe_spending_data_table("contracts")); ?>
        </div>
        <div class="data-table-container">
            <?php echo(_page_controller_get_mwbe_spending_data_table("spendingByIndustries")); ?>
        </div>
        <div style="clear: left"></div>
    </div>

    </div>
    <a href="javascript:" id="return-to-top">back to top</a>
    </div>
  </div>
  <a href="javascript:" id="return-to-top">back to top</a>
</div>
<!-- .landing close tag -->
<?php echo(_page_controller_get_footer()); ?>
