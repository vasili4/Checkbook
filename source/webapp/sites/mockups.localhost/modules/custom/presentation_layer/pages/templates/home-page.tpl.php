
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
    <a href="javascript:void(0);" class="domain">
      <div class="budget-ico"></div>
      <div class="label">budget</div>
      <div><?php echo($domains[0]["value"]); ?></div>
    </a>
    <a href="javascript:void(0);" class="domain">
      <div class="revenue-ico"></div>
      <div class="label">revenue</div>
      <div><?php echo($domains[1]["value"]); ?></div>
    </a>
    <a href="/spending_landing" class="domain spending">
      <div class="spending-ico"></div>
      <div class="label">spending</div>
      <div><?php echo($domains[2]["value"]); ?></div>
    </a>
    <a href="javascript:void(0);" class="domain">
      <div class="contracts-ico"></div>
      <div class="label">contracts</div>
      <div><?php echo($domains[3]["value"]); ?></div>
    </a>
    <a href="javascript:void(0);" class="domain">
      <div class="payroll-ico"></div>
      <div class="label">payroll</div>
      <div><?php echo($domains[4]["value"]); ?></div>
    </a>
  </div>

</div>
<?php echo(_page_controller_get_footer()); ?>
