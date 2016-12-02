<?php
$sub_domains = $viewModel[viewConfig][sub_domains];
$spending_types = $viewModel[viewConfig][spending_types];
?>
<div class="filter">
    <div class="subdomain-filter">
        <span class="label">sub domain</span>
        <?php foreach($sub_domains as $type) {?>
            <div class="subdomain<?php echo(strtoupper($type["name"]) == "M/WBE" ? " active" : "");?>"><span><?php echo($type["amount"]);?></span> <span><?php echo($type["name"]);?></span></div>
        <?php } ?>
        <div class="mwbe-filter-button">select filter</div>
    </div>
    <div class="mwbe-filter">
        <div>total m/wbe</div>
        <div>asian american</div>
        <div>black american</div>
        <div>women</div>
        <div>hispanic american</div>
    </div>
    <div class="spending-filter"><span class="label">spending types</span>
        <?php foreach($spending_types as $type) { ?>
            <div class="subdomain<?php echo(strtoupper($type["name"]) == "TOTAL" ? " active" : "");?>"><span><?php echo($type["amount"]);?></span> <span><?php echo($type["name"]);?></span></div>
        <?php } ?>
    </div>
</div>
