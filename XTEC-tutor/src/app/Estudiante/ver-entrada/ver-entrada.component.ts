// noinspection TypeScriptValidateJSTypes

import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-ver-entrada',
  templateUrl: './ver-entrada.component.html',
  styleUrls: ['./ver-entrada.component.scss']
})
export class VerEntradaComponent implements OnInit {
  public id: any;
  public cuerpo: string = '<h1 style="text-align: justify;"><strong>Toma de la muestra y conservaci&oacute;n.&nbsp; </strong></h1> <p style="text-align: justify;">Se toma la muestra de orina al finalizar la semana y la jornada de trabajo; se colecta en frascos de polietileno, previamente lavados con soluci&oacute;n de &aacute;cido n&iacute;trico al 20 % durante 12 h. No se necesita preservante,&nbsp;<br />pero el frasco debe llenarse por completo para prever la oxidaci&oacute;n del As+3 y As+5. Se&nbsp;<br />debe mantener en refrigeraci&oacute;n a 4 &ordm;C y analizarse preferentemente dentro de pocas&nbsp;<br />horas, si es necesario mantenerlo m&aacute;s tiempo, debe almacenarse en congelaci&oacute;n.<br />Se ha reportado que la muestra de orina tiene una p&eacute;rdida de ars&eacute;nico del 15 %&nbsp;<br />debido al dep&oacute;sito o adsorci&oacute;n de las paredes durante 3 d&iacute;as a temperatura ambiente.&nbsp;<br />Se proh&iacute;be comer alimentos marinos 48 h antes de tomar la muestra.<br />Valores de referencia:<br />&ndash; Ars&eacute;nico inorg&aacute;nico en la orina (final de la semana):<br />&bull; 10-50 &mu;g/L</p> <p style="text-align: justify;">35 &mu;g/L.<br />&bull; 10 &mu;g/g de creatinina.<br />&bull; &lt;20 &mu;g/g de creatinina.<br /><strong>&ndash; Ars&eacute;nico total en la orina:</strong><br />&bull; &lt;40 &mu;g/g de creatinina.<br />&bull; &lt;100 &mu;g/g de creatinina.<br />&bull; &lt;150 &mu;g/g de creatinina.<br /><strong>&ndash; Ars&eacute;nico en la sangre:&nbsp;</strong><br />&bull; 1,5-2,5 &mu;g/L.<br />&bull; 0,2 mg/L.<br /><strong>&ndash; Ars&eacute;nico en el cabello:</strong><br />&bull; &lt;1 mg/kg.<br />&bull; &lt;1 &mu;g/g peso seco.</p> <p style="text-align: justify;"><br /><strong>Niveles de acci&oacute;n biol&oacute;gica:&nbsp;</strong><br /><strong>&ndash; Ars&eacute;nico inorg&aacute;nico en la orina:</strong><br />&bull; 100-300 &mu;g/L.<br />&bull; &lt;130 &mu;g/g de creatinina.<br />&bull; Threshold limit value (TLV):&lt;50 &mu;g/m3<br />&bull; 50 &mu;g/g de creatinina.<br /><strong>&ndash; Ars&eacute;nico total en la orina:&nbsp;</strong><br />&bull; &lt;100 &mu;g/L.&nbsp;<br />&bull; 600 &mu;g/L.</p> <p style="text-align: justify;"><br /><strong>Cadmio</strong><br />En la naturaleza existe en bajas concentraciones junto con el zinc en forma de&nbsp;<br />dep&oacute;sitos de sulfuros, pero la actividad humana ha provocado la contaminaci&oacute;n con&nbsp;<br />cadmio en todos los continentes. En &aacute;reas remotas (no habitadas) se ha encontrado&nbsp;<br />una concentraci&oacute;n de cadmio en el aire menor que 1 ?g/m3<br />. En el agua de oc&eacute;anos&nbsp; abiertos la concentraci&oacute;n var&iacute;a entre 0,02 y 0,1 &mu;g/L. En los suelos y las rocas la&nbsp;<br />concentraci&oacute;n tiene un rango amplio, en los suelos puede estar entre 0,1 y 1 mg/kg.&nbsp;<br />En ocasiones se han encontrado concentraciones en vegetales, frutas y granos entre&nbsp;<br />0,01 y 0,1 mg/kg.<br />La ingesti&oacute;n diaria en la dieta va a estar en dependencia de los h&aacute;bitos alimentarios&nbsp;<br />de cada persona. Para los fumadores existe una fuente adicional, pues se inhala por&nbsp;<br />un solo cigarrillo de 0,1 a 0,2 &mu;g de cadmio.</p>';

  constructor(private route: ActivatedRoute) { }

  ngOnInit(): void {
    this.id = this.route.snapshot.params.id;
  }

}
