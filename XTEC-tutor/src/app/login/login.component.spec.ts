import { async, inject, TestBed } from '@angular/core/testing';
import { HttpClientModule } from '@angular/common/http';
import {FileService} from "../_service/file.service";
import { LoginComponent } from './login.component';

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

  it ('Verificar a Estudiante registrado', async(() => {
    const service: FileService = TestBed.get(FileService);
    service.login('2018099536', 'f').then(tipo => {
      const type:any = tipo;
      expect(type).toBe(2);
    });
  }));

  it ('Verificar a administrador registrado', async(() => {
    const service: FileService = TestBed.get(FileService);
    service.login('admin', 'admin').then(tipo => {
      const type:any = tipo;
      expect(type).toBe(1);
    });
  }));

  it ('Verificar credenciales inválidas', async(() => {
    const service: FileService = TestBed.get(FileService);
    service.login('test', 'test').then(tipo => {
      const type:any = tipo;
      expect(type).toBe(0);
    });
  }));

});
