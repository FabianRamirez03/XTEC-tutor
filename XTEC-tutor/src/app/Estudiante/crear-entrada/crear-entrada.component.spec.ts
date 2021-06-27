import { async, inject, TestBed } from '@angular/core/testing';
import { HttpClientModule } from '@angular/common/http';
import { CrearEntradaComponent } from './crear-entrada.component';
import {FileService} from "../../_service/file.service";

describe('CrearEntradaComponent', () => {

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
