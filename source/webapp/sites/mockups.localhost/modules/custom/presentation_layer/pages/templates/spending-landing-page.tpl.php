<div class="domain-select-overlay"></div>
<nav>
    <div class="nav-logo">
        <a href="#">
            <div class="main-logo-notag"></div>
        </a>
    </div>
    <div><a href="#">home</a></div>
    <div class="nav-dropdown active"><a href="#">domains</a></div>
    <div><a href="#">bonds</a></div>
    <div><a href="#">trends</a></div>
    <div><a href="#">search&nbsp;tools</a></div>
    <div><a href="#">help</a></div>
</nav>
<div class="nav-domains active">
    <div class="nav-domains__list">
        <div class="spending">
            <div>$0.00B</div>
            <div>spending</div>
        </div>
        <div class="budget">
            <div>$0.00B</div>
            <div>budget</div>
        </div>
        <div class="revenue">
            <div>$0.00B</div>
            <div>revenue</div>
        </div>
        <div class="contracts">
            <div>$0.00B</div>
            <div>contracts</div>
        </div>
        <div class="payroll">
            <div>$0.00B</div>
            <div>payroll</div>
        </div>
    </div>
</div>
<div class="landing">
    <div class="landing-filters">
        <div class="landing-head"> <span class="page-title">citywide total spending $9.90B</span> <span class="page-subtitle">optional subtitle here</span> <span class="page-breadcrumb">home - domain: spending - citywide</span> </div>
        <div class="year-filter"> <span>fiscal year filter: </span> <select>
                <option>2016(Jul 1, 2015 - Jun 20, 2016)</option>
            </select>
            <!--change to div select element-->
        </div>
    </div>
    <div class="filter">
        <div class="subdomain-filter"> <span class="label">sub domain</span>
            <div class="subdomain"> <span>$0.00B</span> <span>all (citywide)</span> </div>
            <div class="subdomain"> <span>$0.00B</span> <span>m/wbe</span> </div>
            <div class="subdomain"> <span>$0.00B</span> <span>m/wbe (sub&nbsp;vendor)</span> </div>
            <div class="subdomain"> <span>$0.00B</span> <span>sub&nbsp;vendors</span> </div>
            <div class="subdomain"> <span>$0.00B</span> <span>sub&nbsp;vendors (m/wbe)</span> </div>
            <div class="subdomain"> <span>$0.00B</span> <span>other&nbsp;government entities</span> </div>
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
        <div class="snapshots-container">
            <div class="domain-label">snapshots</div>
            <div class="snapshots">
                <div class="person">
                    <div class="image"></div>
                    <div class="data">
                        <div>3/5</div>
                        <div>insert text here</div>
                    </div>
                </div>
                <div class="pie">
                    <div class="image"></div>
                    <div class="data">
                        <div>3/5</div>
                        <div>insert text here</div>
                    </div>
                </div>
                <div class="bar">
                    <div class="image"></div>
                    <div class="data">
                        <div>3/5</div>
                        <div>insert text here</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="charts-container">
            <div class="domain-label">visualization title</div>
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
        <div class="data-tables-container">
            <div style="margin-top: 30px; display: inline; position: relative; width: 940px; float: left;">
                <?php echo(_page_controller_get_mwbe_spending_data_table("checks")); ?>
            </div>
            <div style="margin-top: 30px; display: inline; position: relative; width: 450px; float: left;">
                <?php echo(_page_controller_get_mwbe_spending_data_table("agencies")); ?>
            </div>
            <div style="margin-top: 30px; display: inline; position: relative; width: 450px; float: left; margin-left: 40px;">
                <?php echo(_page_controller_get_mwbe_spending_data_table("expenseCategories")); ?>
            </div>
            <div style="margin-top: 30px; display: inline; position: relative; width: 940px; float: left;">
                <?php echo(_page_controller_get_mwbe_spending_data_table("primeVendors")); ?>
            </div>
            <div style="margin-top: 30px; display: inline; position: relative; width: 940px; float: left;">
                <?php echo(_page_controller_get_mwbe_spending_data_table("subVendors")); ?>
            </div>
            <div style="margin-top: 30px; display: inline; position: relative; width: 940px; float: left;">
                <?php echo(_page_controller_get_mwbe_spending_data_table("contracts")); ?>
            </div>
            <div style="margin-top: 30px; display: inline; position: relative; width: 940px; float: left;">
                <?php echo(_page_controller_get_mwbe_spending_data_table("spendingByIndustries")); ?>
            </div>
            <div style="clear: left"></div>
        </div>
    </div>
</div>
<!-- .landing close tag -->
<footer>
    <div class="footer__left-links">
        <div class="locale"><span>translate</span>
            <a href="#">
                <div class="globe-icon"></div>
            </a>
        </div>
        <div class="social"><span>social</span>
            <a href="#">
                <div class="googleplus-icon"></div>
            </a>
            <a href="#">
                <div class="twitter-icon"></div>
            </a>
            <a href="#">
                <div class="facebook-icon"></div>
            </a>
            <a href="#">
                <div class="linkedin-icon"></div>
            </a>
            <a href="#">
                <div class="email-icon"></div>
            </a>
        </div>
    </div>
    <div class="footer__right-links">
        <div class="comptroller-logo"></div>
        <div>Office&nbsp;of&nbsp;the&nbsp;Comptroller - City&nbsp;of&nbsp;New&nbsp;York <br> One&nbsp;Centre&nbsp;Street, New&nbsp;York,&nbsp;NY | Phone:&nbsp;212.669.3916
            <div> <span>
            <a href="#">disclaimer</a> |
            <a href="#">privacy&nbsp;policy</a> |
            <a href="#">language&nbsp;disclaimer</a>
      </span>
                <div>&copy; 2016,&nbsp;The&nbsp;New&nbsp;York City&nbsp;Comptroller's&nbsp;Office</div>
                <div class="footer__open-source-disclaimer">checkbooknyc&nbsp;is&nbsp;open&nbsp;source&nbsp;software</div>
            </div>
</footer>