//
// Diese Datei wurde mit der JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.7 generiert 
// Siehe <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Änderungen an dieser Datei gehen bei einer Neukompilierung des Quellschemas verloren. 
// Generiert: 2018.02.22 um 11:14:03 PM CET 
//


package net.opengis.kml._2;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElementRef;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java-Klasse für DeleteType complex type.
 * 
 * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
 * 
 * <pre>
 * &lt;complexType name="DeleteType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element ref="{http://www.opengis.net/kml/2.2}AbstractFeatureGroup" maxOccurs="unbounded" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "DeleteType", propOrder = {
    "abstractFeatureGroup"
})
public class DeleteType {

    @XmlElementRef(name = "AbstractFeatureGroup", namespace = "http://www.opengis.net/kml/2.2", type = JAXBElement.class, required = false)
    protected List<JAXBElement<? extends AbstractFeatureType>> abstractFeatureGroup;

    /**
     * Gets the value of the abstractFeatureGroup property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the abstractFeatureGroup property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getAbstractFeatureGroup().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link JAXBElement }{@code <}{@link AbstractContainerType }{@code >}
     * {@link JAXBElement }{@code <}{@link NetworkLinkType }{@code >}
     * {@link JAXBElement }{@code <}{@link AbstractOverlayType }{@code >}
     * {@link JAXBElement }{@code <}{@link ScreenOverlayType }{@code >}
     * {@link JAXBElement }{@code <}{@link GroundOverlayType }{@code >}
     * {@link JAXBElement }{@code <}{@link AbstractFeatureType }{@code >}
     * {@link JAXBElement }{@code <}{@link PhotoOverlayType }{@code >}
     * {@link JAXBElement }{@code <}{@link DocumentType }{@code >}
     * {@link JAXBElement }{@code <}{@link FolderType }{@code >}
     * {@link JAXBElement }{@code <}{@link PlacemarkType }{@code >}
     * 
     * 
     */
    public List<JAXBElement<? extends AbstractFeatureType>> getAbstractFeatureGroup() {
        if (abstractFeatureGroup == null) {
            abstractFeatureGroup = new ArrayList<JAXBElement<? extends AbstractFeatureType>>();
        }
        return this.abstractFeatureGroup;
    }

    public boolean isSetAbstractFeatureGroup() {
        return ((this.abstractFeatureGroup!= null)&&(!this.abstractFeatureGroup.isEmpty()));
    }

    public void unsetAbstractFeatureGroup() {
        this.abstractFeatureGroup = null;
    }

    public void setAbstractFeatureGroup(List<JAXBElement<? extends AbstractFeatureType>> value) {
        this.abstractFeatureGroup = value;
    }

}
