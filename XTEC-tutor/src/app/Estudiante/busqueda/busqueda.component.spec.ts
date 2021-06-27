import { async, inject, TestBed } from '@angular/core/testing';
import { HttpClientModule } from '@angular/common/http';
import {FileService} from "../../_service/file.service";

import { BusquedaComponent } from './busqueda.component';

describe('BusquedaComponent', () => {


  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [HttpClientModule ],
      providers: [FileService]
    })
    .compileComponents();
  });

  it('Servicio creado', inject([FileService], (service: FileService) => {
    expect(service).toBeTruthy();
  }));


  it ('Verificar getCarreras', async(() => {
    const service: FileService = TestBed.get(FileService);
    service.getCarreras().subscribe(resp => {
      expect(resp).toBeDefined();
    });
  }));

});
