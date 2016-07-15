/**
 * MicroStrategy SDK Sample
 *
 * Copyright © 2009 MicroStrategy Incorporated. All Rights Reserved.
 *
 * MICROSTRATEGY MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE
 * SUITABILITY OF THIS SAMPLE CODE, EITHER EXPRESS OR IMPLIED, INCLUDING
 * BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. MICROSTRATEGY SHALL NOT
 * BE LIABLE FOR ANY DAMAGES SUFFERED BY LICENSEE AS A RESULT OF USING,
 * MODIFYING OR DISTRIBUTING THIS SAMPLE CODE OR ITS DERIVATIVES.
 *
 *
 *
 * CustomoDataReportTransform is a sample report transform that that
 * outputs a simplified version of the report xml. <br>
 * <br>
 * The XML has the following format:
 * <code>
 * <?xml version="1.0" encoding="utf-8"?>
 * <mstr-report>
 *   <information>
 *     <report-name>Report 1</report-name>
 *     <report-id>6E2FB3E7439CE9EA9AD468AB09B1FA6F</report-id>
 *     <report-desc></report-desc>
 *     <number-of-rows>4</number-of-rows>
 *     <number-of-cols>2</number-of-cols>
 *     <message-id>BB2FB3E7439CE9EA9AD468AB09B1FA6F</message-id>
 *     <state-id>0</state-id>
 *     <block-begin>1</block-begin>
 *     <block-count>50</block-count>
 *   </information>
 *   <report-data>(optional)
 *     <titles>
 *       <col pos="1">Subcategory</col>
 *       <col pos="2">Dollar Sales</col>
 *       <col pos="3">Unit Sales</col>
 *     </titles>
 *     <rows>
 *       <row>
 *         <col pos="1">Audio</col>
 *         <col pos="2">$ 39.00</col>
 *         <col pos="3">3</col>
 *       </row>
 *       <row>
 *         <col pos="1">Christmas</col>
 *         <col pos="2">$ 62.00</col>
 *         <col pos="3">6</col>
 *       </row>
 *     </rows>
 *   <report-data>
 *   <error>Error message</error>(optional)
 * </mstr-report>
 * <code>
 */
package com.microstrategy.sdk.samples.transforms;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import com.microstrategy.utils.xml.XMLUtils;
import com.microstrategy.web.app.transforms.ReportTransformHelper;
import com.microstrategy.web.beans.MarkupOutput;
import com.microstrategy.web.beans.ReportBean;
import com.microstrategy.web.beans.Transformable;
import com.microstrategy.web.beans.WebBeanException;
import com.microstrategy.web.objects.WebHeaders;
import com.microstrategy.web.objects.WebObjectsException;
import com.microstrategy.web.objects.WebReportData;
import com.microstrategy.web.objects.WebReportGrid;
import com.microstrategy.web.objects.WebRow;
import com.microstrategy.web.objects.WebTitle;
import com.microstrategy.web.tags.Tag;
import com.microstrategy.web.tags.TagsFactory;
import com.microstrategy.web.transform.AbstractTransform;
import com.microstrategy.web.transform.FormalParameter;
import com.microstrategy.web.transform.FormalParameterImpl;
import com.microstrategy.webapi.EnumDSSXMLTemplateUnitType;


//Declare our own report transform...
public class CustomoDataReportTransform extends AbstractTransform {

    String _reportID = "0";
    //String[] _columnNames;
    List<String> _columnNames = new ArrayList<String>(); 
    protected FormalParameter _baseNode;

    // Declare our default no-args constructor
    public CustomoDataReportTransform() {
        super();

        _baseNode = addFormalParameter("baseNode", FormalParameter.PARAM_TYPE_STRING, "atom:feed", "This formal parameter determines the name of the base node.");
    }

    public String getDescription() {
        return "This is a report transform that renders a simplified version of the report xml";
    }

    // This method is called when output needs to be generated...
    public void transform(Transformable data, MarkupOutput out) {
        // Get the type-specific interface...
        ReportBean rb = (ReportBean) data;

        renderSimpleXMLReport(out, rb);
    }

    /**
     * This method renders a simplified version of the report xml
     * @param out The {@link MarkupOutput}
     * @param rb The {@link ReportBean}
     */
    private void renderSimpleXMLReport(MarkupOutput out, ReportBean rb) {

        // Generate some header information...
        Tag mstrReportTag = getTagsFactory().newTag(_baseNode.getValue().toString());
        mstrReportTag.setAttribute("xml:base", "http://fraterno:8080/apex/PANDAS_001_REPORT_EXECUTE.oData?");
        mstrReportTag.setAttribute("xmlns:atom", "http://www.w3.org/2005/Atom");
        mstrReportTag.setAttribute("xmlns:d", "http://schemas.microsoft.com/ado/2007/08/dataservices");
        mstrReportTag.setAttribute("xmlns:m", "http://schemas.microsoft.com/ado/2007/08/dataservices/metadata");

        try {
            // Get the report data from the report bean...
            WebReportData wrd = rb.getReportData();
            
            // Get the Report Grid...
            WebReportGrid wrg = wrd.getWebReportGrid();

            generateInformation(mstrReportTag, rb, wrd);

            if (isCrosstabReport(wrg)) {
                mstrReportTag.addChild("error").addTextChild("Report is not in tabular mode");
            } else if (isMergeRowHeaders(rb)) {
                mstrReportTag.addChild("error").addTextChild("Report has merge row headers." +
                    "Make sure the report property 'MergeCells' is off, this can be done on the GUI through the grid editor");
            } else {

            	generateTitles(mstrReportTag, wrg);
            	
            	generateRows(mstrReportTag, wrg);
            }
        } catch (WebObjectsException woe) {
            mstrReportTag.addChild("error").addTextChild("WebObjectsException encountered: " + XMLUtils.encodeXMLAttribute(woe.toString()));
        } catch (WebBeanException wbe) {
            mstrReportTag.addChild("error").addTextChild("WebBeanException encountered: " + XMLUtils.encodeXMLAttribute(wbe.toString()));
        }

        mstrReportTag.render(out);
    }

    /**
     * @return whether the report has merge row headers on
     */
    private boolean isMergeRowHeaders(ReportBean rb) {
        String propValue = ReportTransformHelper.getReportPropertyValue(rb, "MergeCells");

        return "-1".equalsIgnoreCase(propValue);
    }

    /**
     * Generates the information section
     * @param mstrReportTag
     * @param rb
     * @param wrd
     * @throws WebBeanException
     */
    private void generateInformation(Tag mstrReportTag, ReportBean rb, WebReportData wrd) throws WebBeanException {

    	//   <information>   	
    	Tag idTag = mstrReportTag.addChild("atom:id");
    	_reportID = rb.getObjectID();
    	idTag.addTextChild("http://fraterno:8080/apex/PANDAS_001_REPORT_EXECUTE.oData?reportId=" + _reportID);

    	Tag titleTag = mstrReportTag.addChild("atom:title");
    	titleTag.setAttribute("type", "text");
    	titleTag.addTextChild(XMLUtils.encodeXMLAttribute(rb.getObjectName()));
    	
    	Tag authorTag = mstrReportTag.addChild("atom:author");
    	Tag authornameTag = authorTag.addChild("name");
    	authornameTag.addTextChild(XMLUtils.encodeXMLAttribute("Davide Moraschi"));
    	Tag authoremailTag = authorTag.addChild("email");
    	authoremailTag.addTextChild(XMLUtils.encodeXMLAttribute("davidem@eurostrategy.net"));

    	Tag updatedTag = mstrReportTag.addChild("atom:updated");
    	SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
        Date now = new Date();
        String strDate = sdfDate.format(now);
        updatedTag.addTextChild(strDate);

    	Tag linkTag = mstrReportTag.addChild("atom:link");
    	linkTag.setAttribute("rel", "self");
    	linkTag.setAttribute("title", rb.getObjectName());
    	linkTag.setAttribute("href", rb.getObjectID());
    	
    }

    /**
     * Generates the titles section
     * @param reportDataTag The report-data tag
     * @param wrg The report grid
     * @throws WebObjectsException
     */
    private void generateTitles(Tag reportDataTag, WebReportGrid wrg) throws WebObjectsException {
        //   <titles>
        //Tag titlesTag = reportDataTag.addChild("titles");

        // Loop through the row titles...
        for (int i = 0; i < wrg.getRowTitles().size(); i++) {
            // Get the ith row title...
            WebTitle wt = wrg.getRowTitles().get(i);

            if (wt.getGridSubTitles().size() > 1) { // has attribute forms
                for (int j = 0; j < wt.getGridSubTitles().size(); j++) {
                    //generateColTag(titlesTag, i + j + 1, wt.getWebTemplateUnit().getName() + " " + wt.getGridSubTitles().get(j).getName(), null);
                	_columnNames.add(wt.getWebTemplateUnit().getName()+ " " + wt.getGridSubTitles().get(j).getName());
                }
            } else {
                //generateColTag(titlesTag, i + 1, wt.getWebTemplateUnit().getName(), null);
            	_columnNames.add(wt.getWebTemplateUnit().getName());
            }
        }

        // Get the last row of column headers...
        WebHeaders whs = wrg.getColumnHeaders().get(wrg.getColumnHeaders().size() - 1);

        // Loop through the column headers...
        for (int j = 0; j < whs.size(); j++) {
        	//String nombre = whs.get(j).getDisplayName();
        	_columnNames.add(whs.get(j).getDisplayName());
        	
        }
    }

    /**
     * Generates the rows section
     * @param reportDataTag The report-data tag
     * @param wrg The report grid
     */
    private void generateRows(Tag reportDataTag, WebReportGrid wrg) {
        
        // Loop through all of the header/grid rows...
        for (int i = 0; i < wrg.getGridRows().size(); i++) {
            // Open a new row...
            //     <row>
            Tag entryTag = reportDataTag.addChild("atom:entry");
            Tag entryidTag = entryTag.addChild("atom:id");

            entryidTag.addTextChild(String.valueOf(i + 1));
        	
            Tag linkTag = entryTag.addChild("atom:link");
        	linkTag.setAttribute("rel", "edit");
        	linkTag.setAttribute("title", "row");
        	linkTag.setAttribute("href", "row("+String.valueOf(i + 1)+")");
        	
        	Tag titleTag = entryTag.addChild("atom:title");
/*
        	Tag updatedTag = entryTag.addChild("updated");
        	SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
            Date now = new Date();
            String strDate = sdfDate.format(now);
            updatedTag.addTextChild(strDate);
*/
        	Tag authorTag = entryTag.addChild("atom:author");
        	Tag authornameTag = authorTag.addChild("name");
        	//authornameTag.setAttribute("contact", "davidem@eurostrategy.net");
/*        	
        	Tag categoryTag = entryTag.addChild("category");
        	categoryTag.setAttribute("term", "MicroStrategy.oData");
        	categoryTag.setAttribute("scheme", "http://schemas.microsoft.com/ado/2007/08/dataservices/scheme");
*/
        	Tag contentTag = entryTag.addChild("atom:content");
        	contentTag.setAttribute("type", "application/xml");

        	Tag propertiesTag = contentTag.addChild("m:properties");

            WebHeaders wh = wrg.getRowHeaders().get(i);
            WebRow wr = wrg.getGridRows().get(i);

            // Loop through row headers...
            for (int j = 0; j < wh.size(); j++) {
                generateColTag(propertiesTag, j + 1, wh.get(j).getDisplayName(), "3");
            }

            // Loop through grid rows...
            for (int j = 0; j < wr.size(); j++) {
                generateColTag(propertiesTag, j + 1 + wh.size(), wr.get(j).getValue(), String.valueOf(wr.get(j).getSemantics()));
            }
        }
    }

    /**
     * Add a col tag
     * @param parentTag
     * @param index
     * @param value
     */
    private void generateColTag(Tag parentTag, int index, String value, String typeofcolumn) {

        //typeofcolumn: 1=metric, 2=total
    	//Tag colTag = parentTag.addChild("d:Col" + String.valueOf(index));
    	Tag colTag = parentTag.addChild("d:" + _columnNames.get(index-1));

    	//The values are 1 for Edm.DateTime, 2 for Edm.Double, 3 for Edm.String, 4 for image, 5 for anchor link, 6 for e-mail, 7 for HTML tag, 8 for Edm.DateTime(?), and 9 for Edm.Time.
    	
    	switch (Integer.parseInt(typeofcolumn)) 
    	{
    	case 1: colTag.setAttribute("m:type", "Edm.DateTime");
        break;
    	case 2: colTag.setAttribute("m:type", "Edm.Double");
        break;
    	case 3: colTag.setAttribute("m:type", "Edm.String");
        break;
    	case 8: colTag.setAttribute("m:type", "Edm.DateTime");
        break;
    	case 9: colTag.setAttribute("m:type", "Edm.Time");
        break;
    	default: colTag.setAttribute("m:type", "Edm.String");
        break;
    	}
    	
    	if(_columnNames.get(index-1).startsWith("fecha")|| _columnNames.get(index-1).startsWith("hora") || _columnNames.get(index-1).startsWith("fhora")) 
        {colTag.setAttribute("m:type", "Edm.DateTime");}
    	

/*
        if(Integer.parseInt(typeofcolumn) == 2 || Integer.parseInt(typeofcolumn) == 2)
        {colTag.setAttribute("m:type", "Edm.Double");}
        else
        {colTag.setAttribute("m:type", typeofcolumn);}
 */       
        colTag.addTextChild(XMLUtils.encodeXMLAttribute(value));
    }

    /**
     * @param wrg The {@link WebReportGrid}
     * @return whether the report is a crosstab report
     */
    private boolean isCrosstabReport(WebReportGrid wrg) {
        return wrg.getColumnTitles().size() > 1 ||
            (wrg.getColumnTitles().size() == 1 &&
                wrg.getColumnTitles().get(0).getType() != EnumDSSXMLTemplateUnitType.DssXmlTemplateMetrics);
    }

    // Indicate the type of bean that this transform supports...
    public Class getSupportedBeanType() {
        return ReportBean.class;
    }

    /**
     * Convenience method for obtaining an instance of the {@link TagsFactory} class.
     * @return a {@link TagsFactory} instance to use for generating
     * {@link Tag} instances
     */
    public TagsFactory getTagsFactory() {
        return TagsFactory.getInstance();
    }

    /**
     * Adds a formal parameter for this transform with the given information
     * @param name the name of the formal parameter
     * @param type the type of the formal parameter, as defined in the <code>FormalParameter</code> constants.
     * @param defaultValue the default value
     * @param description Description of the FP, to use by the style catalog.
     * @return the FormalParameter created.
     */
    public FormalParameter addFormalParameter(String name, int type, Object defaultValue, String description) {
        FormalParameterImpl __result;

        __result = new FormalParameterImpl(name, type);
        __result.setDefaultValue(defaultValue);
        __result.setDescription(description);
        addFormalParam(__result);

        return __result;
    }
}