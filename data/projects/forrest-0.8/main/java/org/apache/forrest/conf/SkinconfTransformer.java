/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.forrest.conf;

import java.awt.Color;
import java.io.IOException;
import java.util.Map;

import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.transformation.AbstractTransformer;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

public class SkinconfTransformer
  extends AbstractTransformer {

          /**
     * Setup
     */
    public void setup(SourceResolver resolver, Map objectModel,
                      String src, Parameters parameters)
    throws ProcessingException, SAXException, IOException {
        /*final boolean append = parameters.getParameterAsBoolean("append", false);
        final String  logfilename = parameters.getParameter("logfile", null);*/
    }
    
   /**
     * Receive notification of the beginning of an element.
     */
    public void startElement(String uri, String loc, String raw, Attributes a)
    throws SAXException {
        /*
        this.log ("startElement", "uri="+uri+",local="+loc+",raw="+raw);
        for (int i = 0; i < a.getLength(); i++) {
            this.log ("            ", new Integer(i+1).toString()
                 +". uri="+a.getURI(i)
                 +",local="+a.getLocalName(i)
                 +",qname="+a.getQName(i)
                 +",type="+a.getType(i)
                 +",value="+a.getValue(i));
        }
        */
        Attributes outAttributes = a;
        
        if("color".equals(loc)) {
            
            AttributesImpl newAttributes = new AttributesImpl(a);
            
            String value=null;
            String highlight=null;
            String lowlight=null;
            String font=null;
            String link=null;            
            String vlink=null;
            String hlink=null;
            
            for (int i = 0; i < a.getLength(); i++) {
                if("value".equals(a.getLocalName(i))){
                   value=a.getValue(i); 
                }else if("highlight".equals(a.getLocalName(i))){
                   highlight=a.getValue(i); 
                }else if("lowlight".equals(a.getLocalName(i))){
                   lowlight=a.getValue(i); 
                }else if("font".equals(a.getLocalName(i))){
                   font=a.getValue(i); 
                }else if("link".equals(a.getLocalName(i))){
                   link=a.getValue(i); 
                }else if("vlink".equals(a.getLocalName(i))){
                   vlink=a.getValue(i); 
                }else if("hlink".equals(a.getLocalName(i))){
                   hlink=a.getValue(i); 
                }              
            }
            
            if(value==null){
              value="#dd0000";// a default "visible" color
              newAttributes.addAttribute("","value","value","",value);
            }   
            
            Color valueColor = Color.decode(value);
            float brightness = Color.RGBtoHSB(valueColor.getRed(),
                                              valueColor.getGreen(),
                                              valueColor.getBlue(),
                                              null)[2];
            
            if(highlight==null){
                highlight = "#"+Integer.toHexString(valueColor.brighter().getRGB()).substring(2);
                newAttributes.addAttribute("","highlight","highlight","",highlight);
            } 

            if(lowlight==null){
                lowlight = "#"+Integer.toHexString(valueColor.darker().getRGB()).substring(2);
                newAttributes.addAttribute("","lowlight","lowlight","",lowlight);
            }   
            
            if(font==null){
                if(brightness<0.5) {
                    font="#ffffff";
                }
                else{   
                    font="#000000";
                }
                newAttributes.addAttribute("","font","font","",font);
            }    

            if(link==null){
                if(brightness<0.5) {
                     link="#7f7fff";
                }
                else{   
                    link="#0000ff";
                }
                newAttributes.addAttribute("","link","link","",link);
            }    

            if(vlink==null){
                if(brightness<0.5) {
                    vlink="#4242a5";
                }
                else{   
                    vlink="#009999";
                }
                newAttributes.addAttribute("","vlink","vlink","",vlink);
            }   
            
            if(hlink==null){
                if(brightness<0.5) {
                    hlink="#0037ff";
                }
                else{   
                    hlink="#6587ff";
                }
                newAttributes.addAttribute("","hlink","hlink","",hlink);
            }   
            
            outAttributes = newAttributes;
        }
        
        if (super.contentHandler!=null) {
            super.contentHandler.startElement(uri,loc,raw,outAttributes);
        }
    }
}
