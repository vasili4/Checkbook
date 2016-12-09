
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

  <div class="home__front-links">
    <div class="home__front-links--domains">
      <div class="domains-img"></div>
      <div class="domain-text">
        <span>How does the city spend your money?<span><br>
          <span class="enter">Enter domains</span>
      </div>
    </div>
    <div class="domain-select">
      <span>select a domain</span>
      <div class="domain-select-close">&times;</div>
      <div class="domain-icons">
        <a href="/spending_landing" class="domain">
          <div class="spending-ico"></div>
          <span>spending</span>
        </a>
        <a href="javascript:void(0);" class="domain">
          <div class="budget-ico"></div>
          <span>budget</span>
        </a>
        <a href="javascript:void(0);" class="domain">
          <div class="revenue-ico"></div>
          <span>revenue</span>
        </a>
        <a href="javascript:void(0);" class="domain">
          <div class="contracts-ico"></div>
          <span>contract</span>
        </a>
        <a href="javascript:void(0);" class="domain">
          <div class="payroll-ico"></div>
          <span>payroll</span>
        </a>
      </div>
    </div>
    <div class="home__front-links--bonds">
      <div class="bonds-img"></div>
      <div class="domain-text">
        <span>How does lending impact our budget?</span><br>
        <span class="enter">Enter bonds</span>
      </div>
    </div>
  </div>
</div>
<?php echo(_page_controller_get_footer()); ?>