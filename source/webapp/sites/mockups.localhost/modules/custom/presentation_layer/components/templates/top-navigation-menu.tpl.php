<div class="domain-select-overlay"></div>
<nav>
    <div class="nav-logo">
        <a href="/">
            <div class="main-logo-notag"></div>
        </a>
    </div>
    <div class="nav-home"><a href="/">home</a></div>
    <div class="nav-dropdown domain-select-nav"><a href="javascript:void(0);">domains</a></div>
    <div class="nav-dropdown trends-select"><a href="javascript:void(0);">trends</a></div>
    <div class="nav-dropdown search-tools-select"><a href="javascript:void(0);">search&nbsp;tools</a></div>
    <div class="nav-dropdown help-select"><a href="javascript:void(0);">help</a></div>
</nav>
<?php $domains = MockData::SpendingByDomains(); ?>
<div class="nav-submenu nav-domains">
    <div class="nav-dropdown__list">
        <a href="javascript:void(0);" class="budget">
            <div><?php echo($domains[0]["name"]); ?></div>
        </a>
        <a href="javascript:void(0);" class="revenue">
            <div><?php echo($domains[1]["name"]); ?></div>
        </a>
        <a href="/spending_landing" class="spending">
            <div><?php echo($domains[2]["name"]); ?></div>
        </a>
        <a href="javascript:void(0);" class="contracts">
            <div><?php echo($domains[3]["name"]); ?></div>
        </a>
        <a href="javascript:void(0);" class="payroll">
            <div><?php echo($domains[4]["name"]); ?></div>
        </a>
    </div>
</div>

<div class="nav-submenu nav-trends">
    <div class="nav-dropdown__list">
        <a href="javascript:void(0);" class="featured-trends">
            <div>featured&nbsp;trends</div>
        </a>
        <a href="javascript:void(0);" class="all trends">
            <div>all&nbsp;trends</div>
        </a>
        <a href="javascript:void(0);" class="financial-trends">
            <div>financial</div>
        </a>
        <a href="javascript:void(0);" class="revenue-capacity-trends">
            <div>revenue&nbsp;capacity</div>
        </a>
        <a href="javascript:void(0);" class="debt-capacity-trends">
            <div>debt&nbsp;capacity</div>
        </a>
        <a href="javascript:void(0);" class="demographic-trends">
            <div>demographic</div>
        </a>
        <a href="javascript:void(0);" class="operational-trends">
            <div>operational</div>
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

<div class="nav-submenu nav-help">
    <div class="nav-dropdown__list">
        <a href="javascript:void(0);" class="new-features-help">
            <div>new&nbsp;features</div>
        </a>
        <a href="javascript:void(0);" class="resources-help">
            <div>resources</div>
        </a>
        <a href="javascript:void(0);" class="instructional-videos-help">
            <div>instructional&nbsp;videos</div>
        </a>
        <a href="javascript:void(0);" class="faq-help">
            <div>faq</div>
        </a>
        <a href="javascript:void(0);" class="supported-browsers-help">
            <div>supported&nbsp;browsers</div>
        </a>
        <a href="javascript:void(0);" class="ask-a-question-help">
            <div>ask&nbsp;a&nbsp;question</div>
        </a>
        <a href="javascript:void(0);" class="report-a-problem-help">
            <div>report&nbsp;a&nbsp;problem </div>
        </a>
    </div>
</div>
