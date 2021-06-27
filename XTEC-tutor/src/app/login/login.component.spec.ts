import { async, ComponentFixture, inject, TestBed } from '@angular/core/testing';
import { HttpClientModule } from '@angular/common/http';
import { LoginComponent } from './login.component';
import {FileService} from "../_service/file.service";

describe('LoginComponent', () => {

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

  it ('Verificar a usuario registrado', async(() => {
    const service: FileService = TestBed.get(FileService);
    service.login('2018099536', 'f').then(tipo => {
      const type:any = tipo;
      expect(type).toBe(2);
    });
  }));


});
