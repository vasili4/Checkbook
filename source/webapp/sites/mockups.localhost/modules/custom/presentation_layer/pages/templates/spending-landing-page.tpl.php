<div class="domain-select-overlay"></div>
<nav>
  <div class="nav-logo">
    <a href="/">
      <div class="main-logo-notag"></div>
    </a>
  </div>
  <div><a href="/">home</a></div>
  <div class="nav-dropdown domain-select"><a href="javascript:void(0);">domains</a></div>
  <div><a href="javascript:void(0);">bonds</a></div>
  <div><a href="javascript:void(0);">trends</a></div>
  <div class="nav-dropdown search-tools-select"><a href="javascript:void(0);">search&nbsp;tools</a></div>
  <div><a href="javascript:void(0);">help</a></div>
</nav>

<div class="nav-submenu nav-domains">
  <div class="nav-dropdown__list">
    <a href="/spending_landing" class="spending">
      <div>$0.00B</div>
      <div>spending</div>
    </a>
    <a href="javascript:void(0);" class="budget">
      <div>$0.00B</div>
      <div>budget</div>
    </a>
    <a href="javascript:void(0);" class="revenue">
      <div>$0.00B</div>
      <div>revenue</div>
    </a>
    <a href="javascript:void(0);" class="contracts">
      <div>$0.00B</div>
      <div>contracts</div>
    </a>
    <a href="javascript:void(0);" class="payroll">
      <div>$0.00B</div>
      <div>payroll</div>
    </a>
  </div>
</div>

<div class="nav-submenu nav-search-tools">
  <div class="nav-dropdown__list">
    <a href="javascript:void(0);" class="advanced-search">
      <div>advanced&nbsp;search</div>
    </a>
    <a href="javascript:void(0);" class="data-feeds">
      <div>data&nbsp;feeds</div>
    </a>
    <a href="javascript:void(0);" class="api">
      <div>api</div>
    </a>
    <a href="javascript:void(0);" class="create-alerts">
      <div>create&nbsp;alerts</div>
    </a>
  </div>
</div>

<div class="landing">
  <div class="landing-filters">
    <div class="landing-head">
      <span class="page-title">M/WBE total spending $9.90B</span>
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
        </div>
      </div>
      <!--change to div select element-->
    </div>
  </div>
  <div class="filter">
    <div class="subdomain-filter"> <span class="label">sub domain</span>
      <div class="subdomain"> <span>$0.00B</span> <span>all (citywide)</span> </div>
      <div class="subdomain"> <span>$0.00B</span> <span>other&nbsp;government entities</span> </div>
      <div class="subdomain"> <span>$0.00B</span> <span>m/wbe</span> </div>
      <div class="subdomain"> <span>$0.00B</span> <span>m/wbe (sub&nbsp;vendor)</span> </div>
      <div class="subdomain"> <span>$0.00B</span> <span>sub&nbsp;vendors</span> </div>
      <div class="mwbe-filter-button">select filter</div>
    </div>
    <div class="mwbe-filter">
      <div>total m/wbe</div>
      <div>asian american</div>
      <div>black american</div>
      <div>women</div>
      <div>hispanic american</div>
    </div>
    <div class="spending-filter"> <span class="label">spending types</span>
      <div class="subdomain"> <span>$0.00B</span> <span>total</span> </div>
      <div class="subdomain"> <span>$0.00B</span> <span>payroll</span> </div>
      <div class="subdomain"> <span>$0.00B</span> <span>capital</span> </div>
      <div class="subdomain"> <span>$0.00B</span> <span>contract</span> </div>
      <div class="subdomain"> <span>$0.00B</span> <span>trust & agency</span> </div>
      <div class="subdomain"> <span>$0.00B</span> <span>other</span> </div>
    </div>
  </div>

  <div class="data-visualization">
    <div class="zc-container">
      <div class="domain-label">m/wbe spending summary</div>
      <div class="chart-toggle">
        <div class="chart-bar active"></div>
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
    <a href="javascript:" id="return-to-top">return to top</a>
    </div>
  </div>
  <a href="javascript:" id="return-to-top">return to top</a>
</div>
<!-- .landing close tag -->
<footer>
  <div class="footer-flex">
    <div class="footer__left-links">
      <div class="locale"><span>translate</span>
        <a href="javascript:void(0);">
          <div class="globe-icon"></div>
        </a>
      </div>
      <div class="social"><span>social</span>
        <a href="javascript:void(0);"><div class="googleplus-icon"></div></a>
        <a href="javascript:void(0);"><div class="twitter-icon"></div></a>
        <a href="javascript:void(0);"><div class="facebook-icon"></div></a>
        <a href="javascript:void(0);"><div class="linkedin-icon"></div></a>
        <a href="javascript:void(0);"><div class="email-icon"></div></a>
      </div>
    </div>
  <div class="footer__right-links">
    <div class="comptroller-logo"></div>
    <div>Office&nbsp;of&nbsp;the&nbsp;Comptroller - City&nbsp;of&nbsp;New&nbsp;York
      <br> One&nbsp;Centre&nbsp;Street, New&nbsp;York,&nbsp;NY | Phone:&nbsp;212.669.3916
    </div>

  </div>
  </div>
  <div class="footer__bottom-links">
    <div class="bottom-container">
      <div>
          <a href="javascript:void(0);">disclaimer</a> |
          <a href="javascript:void(0);">privacy&nbsp;policy</a> |
          <a href="javascript:void(0);">language&nbsp;disclaimer</a>
      </div>
      <div>Copyright&nbsp;&copy;2016,&nbsp;Office&nbsp;of&nbsp;the&nbsp;New&nbsp;York&nbsp;City&nbsp;Comptroller</div>
      <div class="footer__open-source-disclaimer">checkbooknyc&nbsp;is&nbsp;open&nbsp;source&nbsp;software</div>
    </div>
</div>
</footer>
