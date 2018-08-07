package io.reisys.checkbook.bdd.common;

import java.util.ArrayList;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import io.reisys.checkbook.bdd.cucumber.PageObject;
import net.serenitybdd.core.pages.WebElementFacade;

public class CheckbookBasePageObject extends PageObject {

    public ArrayList<String> getVisualizationTitles() {
		ArrayList<String> titles = new ArrayList<String>();
		List<WebElementFacade> visualizationLinks = findAllElements(By.xpath("//div[contains(@class, 'slider-pager')]/a"));
		for(WebElement visualizationLink: visualizationLinks){
			visualizationLink.click();
			WebElement titleClass = findElement(By.xpath("//h2[@class='chart-title']"));
			if(titleClass.isDisplayed()){
				String title = titleClass.getText();
				titles.add(title);
			}
		}	
		return titles;
	}
    
	public ArrayList<String> getWidgetTitles() {
		ArrayList<String> titles = new ArrayList<String>();
		List<WebElementFacade> titleContainers = findAllElements(By.className("tableHeader"));
		for (WebElement titleContainer : titleContainers) {
			WebElement titleHeaderContainer = titleContainer.findElement(By.cssSelector("h2"));
			titles.add(titleHeaderContainer.getText().substring(0, titleHeaderContainer.getText().indexOf("Number")-1));
		}	
		return titles;
	}
}
