<?php

/**
 * @file
 * Default theme implementation to display a single Drupal page.
 *
 * The doctype, html, head and body tags are not in this template. Instead they
 * can be found in the html.tpl.php template in this directory.
 *
 * Available variables:
 *
 * General utility variables:
 * - $base_path: The base URL path of the Drupal installation. At the very
 *   least, this will always default to /.
 * - $directory: The directory the template is located in, e.g. modules/system
 *   or themes/bartik.
 * - $is_front: TRUE if the current page is the front page.
 * - $logged_in: TRUE if the user is registered and signed in.
 * - $is_admin: TRUE if the user has permission to access administration pages.
 *
 * Site identity:
 * - $front_page: The URL of the front page. Use this instead of $base_path,
 *   when linking to the front page. This includes the language domain or
 *   prefix.
 * - $logo: The path to the logo image, as defined in theme configuration.
 * - $site_name: The name of the site, empty when display has been disabled
 *   in theme settings.
 * - $site_slogan: The slogan of the site, empty when display has been disabled
 *   in theme settings.
 *
 * Navigation:
 * - $main_menu (array): An array containing the Main menu links for the
 *   site, if they have been configured.
 * - $secondary_menu (array): An array containing the Secondary menu links for
 *   the site, if they have been configured.
 * - $breadcrumb: The breadcrumb trail for the current page.
 *
 * Page content (in order of occurrence in the default page.tpl.php):
 * - $title_prefix (array): An array containing additional output populated by
 *   modules, intended to be displayed in front of the main title tag that
 *   appears in the template.
 * - $title: The page title, for use in the actual HTML content.
 * - $title_suffix (array): An array containing additional output populated by
 *   modules, intended to be displayed after the main title tag that appears in
 *   the template.
 * - $messages: HTML for status and error messages. Should be displayed
 *   prominently.
 * - $tabs (array): Tabs linking to any sub-pages beneath the current page
 *   (e.g., the view and edit tabs when displaying a node).
 * - $action_links (array): Actions local to the page, such as 'Add menu' on the
 *   menu administration interface.
 * - $feed_icons: A string of all feed icons for the current page.
 * - $node: The node object, if there is an automatically-loaded node
 *   associated with the page, and the node ID is the second argument
 *   in the page's path (e.g. node/12345 and node/12345/revisions, but not
 *   comment/reply/12345).
 *
 * Regions:
 * - $page['help']: Dynamic help text, mostly for admin pages.
 * - $page['highlighted']: Items for the highlighted content region.
 * - $page['content']: The main content of the current page.
 * - $page['sidebar_first']: Items for the first sidebar.
 * - $page['sidebar_second']: Items for the second sidebar.
 * - $page['header']: Items for the header region.
 * - $page['footer']: Items for the footer region.
 *
 * @see template_preprocess()
 * @see template_preprocess_page()
 * @see template_process()
 * @see html.tpl.php
 *
 * @ingroup themeable
 */
?>


<div class="domain-select-overlay"></div>
<nav>
    <div class="nav-logo">
        <a href="#">
            <div class="main-logo-notag"></div>
        </a>
    </div>
    <div><a href="#">home</a></div>
    <div class="nav-dropdown"><a href="#">domains</a></div>
    <div><a href="#">bonds</a></div>
    <div><a href="#">trends</a></div>
    <div><a href="#">resources</a></div>
    <div><a href="#">downloads</a></div>
</nav>

<div class="nav-domains">
    <div class="nav-domains__list">
        <!-- <a href="landing.html" class="spending"> -->
        <div class="spending">
            <div>$0.00B</div>
            <div>spending</div>
            <!-- </a> -->
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

<div class="home">
    <div class="home__logo"></div>
    <div class="search">
        <span class="search-icon"></span>
        <input type="search" class="search__input" placeholder="What can we help you find today?">
        <ul class="search__input-options">
            <li>create alerts</li>
            <li class="recommended-search__button">recommended searches</li>
            <li>advanced search</li>
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
                <span>How does the city spend your money?</span><br>
                <span class="enter">Enter domains</span>
            </div>
        </div>
        <div class="domain-select">
            <span>select a domain</span>

            <div class="domain-select-close">&times;</div>
            <div class="domain-icons">
                <div class="domain">
                    <div class="spending-ico"></div>
                    <span>spending</span>
                </div>
                <div class="domain">
                    <div class="budget-ico"></div>
                    <span>budget</span>
                </div>
                <div class="domain">
                    <div class="revenue-ico"></div>
                    <span>revenue</span>
                </div>
                <div class="domain">
                    <div class="contracts-ico"></div>
                    <span>contract</span>
                </div>
                <div class="domain">
                    <div class="payroll-ico"></div>
                    <span>payroll</span>
                </div>
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

<footer>
    <div class="footer__left-links">
        <div class="locale"><span>translate</span>
            <a href="#">
                <div class="globe-icon"></div>
            </a> <!-- needs image -->
        </div>
        <div class="social"><span>social</span>
            <a href="#">
                <div class="googleplus-icon"></div>
            </a> <!-- needs image -->
            <a href="#">
                <div class="twitter-icon"></div>
            </a> <!-- needs image -->
            <a href="#">
                <div class="facebook-icon"></div>
            </a> <!-- needs image -->
            <a href="#">
                <div class="linkedin-icon"></div>
            </a> <!-- needs image -->
            <a href="#">
                <div class="email-icon"></div>
            </a> <!-- needs image -->
        </div>
    </div>

    <div class="footer__right-links">
        <div class="comptroller-logo"></div>
        <div>Office&nbsp;of&nbsp;the&nbsp;Comptroller -
            City&nbsp;of&nbsp;New&nbsp;York<br>
            One&nbsp;Centre&nbsp;Street,
            New&nbsp;York,&nbsp;NY |
            Phone:&nbsp;212.669.3916
        </div>
			<span>
				<a href="#">disclaimer</a> |
				<a href="#">privacy&nbsp;policy</a> |
				<a href="#">language&nbsp;disclaimer</a>
			</span>

        <div>&copy; 2016,&nbsp;The&nbsp;New&nbsp;York City&nbsp;Comptroller's&nbsp;Office</div>
        <div class="footer__open-source-disclaimer">checkbooknyc&nbsp;is&nbsp;open&nbsp;source&nbsp;software</div>
    </div>
</footer>