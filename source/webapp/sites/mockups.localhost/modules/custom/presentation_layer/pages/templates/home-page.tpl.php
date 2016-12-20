
<?php echo(_page_controller_get_top_navigation_menu()); ?>
<div class="home">
  <div class="home__logo"></div>
  <div class="search">
    <span class="search-icon"></span>
    <input type="search" class="search__input" placeholder="What can we help you find today?">
    <ul class="search__input-options">
      <li class="recommended-search__button">suggested<span></span>searches</li>
    </ul>
    <div class="recommended-search">
      <div class="recommended-search__close">&times;</div>
      <span>m/wbe spending</span>
      <span>sub vendor contracts</span>
      <span>pending contracts</span>
      <span>total nyc budget</span>
      <span>sub vendor spending</span>
      <span>new contracts</span>
      <span>total nyc revenue</span>
      <span>total nyc spending</span>
      <span>m/wbe contracts</span>
      <span>expiring contracts</span>
      <span>total nyc payroll</span>
      <span>total nyc contracts</span>
    </div>
  </div>
  <?php $domains = MockData::SpendingByDomains(); ?>
  <div class="domain-icons">
    <a href="/spending_landing" class="domain">
      <div class="spending-ico"></div>
      <div class="label">spending</div>
      <div><?php echo($domains[0]["value"]); ?></div>
    </a>
    <a href="javascript:void(0);" class="domain">
      <div class="budget-ico"></div>
      <div class="label">budget</div>
      <div><?php echo($domains[1]["value"]); ?></div>
    </a>
    <a href="javascript:void(0);" class="domain">
      <div class="revenue-ico"></div>
      <div class="label">revenue</div>
      <div><?php echo($domains[2]["value"]); ?></div>
    </a>
    <a href="javascript:void(0);" class="domain">
      <div class="contracts-ico"></div>
      <div class="label">contract</div>
      <div><?php echo($domains[3]["value"]); ?></div>
    </a>
    <a href="javascript:void(0);" class="domain">
      <div class="payroll-ico"></div>
      <div class="label">payroll</div>
      <div><?php echo($domains[4]["value"]); ?></div>
    </a>
  </div>

</div>

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
    <div>Office&nbsp;of&nbsp;the&nbsp;Comptroller - City&nbsp;of&nbsp;New&nbsp;York
      <br> One&nbsp;Centre&nbsp;Street, New&nbsp;York,&nbsp;NY | Phone:&nbsp;212.669.3916
    </div>
    <div class="comptroller-logo"></div>
  </div>
  </div>
  <div class="footer__bottom-links">
    <div class="bottom-container">
      <div>
          <a href="http://comptroller.nyc.gov/disclaimer/" target="_blank">disclaimer</a> |
          <a href="http://comptroller.nyc.gov/privacy-policy/" target="_blank">privacy&nbsp;policy</a> |
          <a href="http://comptroller.nyc.gov/language-disclaimer/" target="_blank">language&nbsp;disclaimer</a>
      </div>
      <div>Copyright&nbsp;&copy;2016,&nbsp;Office&nbsp;of&nbsp;the&nbsp;New&nbsp;York&nbsp;City&nbsp;Comptroller</div>
      <div>
        <a href="https://github.com/NYCComptroller/Checkbook " target="_blank">Checkbook&nbsp;NYC&nbsp;is&nbsp;Open&nbsp;Source&nbsp;Software</a>
      </div>
    </div>
</div>
</footer>
