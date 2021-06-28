import { async, inject, TestBed } from '@angular/core/testing';
import { HttpClientModule } from '@angular/common/http';
import {FileService} from "../../_service/file.service";

import { MainComponent } from './main.component';

describe('MainComponent', () => {

  beforeEach(async () => {
    TestBed.configureTestingModule({
      imports: [HttpClientModule ],
      providers: [FileService]
    })
    .compileComponents();
  });


  it('Servicio creado', inject([FileService], (service: FileService) => {
    expect(service).toBeTruthy();
  }));

  it ('Carreras solicitas', async(() => {
    const service: FileService = TestBed.get(FileService);
    service.getCarreras().subscribe((resp:any) => expect(resp).toBeDefined())
  }));


});
