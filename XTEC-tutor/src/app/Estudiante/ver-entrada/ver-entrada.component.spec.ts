import { async, inject, TestBed } from '@angular/core/testing';
import { HttpClientModule } from '@angular/common/http';
import {FileService} from "../../_service/file.service";

import { VerEntradaComponent } from './ver-entrada.component';

describe('VerEntradaComponent', () => {


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

  it ('Conseguir la información de la entrada', async(() => {
    const service: FileService = TestBed.get(FileService);
    service.obtenerEntrada('69').subscribe(resp => {
      expect(resp).toBeDefined();
    });
  }));

  it ('Conseguir los comentarios de la entrada', async(() => {
    const service: FileService = TestBed.get(FileService);
    service.getComentarios('69').subscribe(resp => {
      expect(resp).toBeDefined();
    });
  }));

});
