import { async, inject, TestBed } from '@angular/core/testing';
import { HttpClientModule } from '@angular/common/http';
import {FileService} from "../../_service/file.service";

import { StudentNavBarComponent } from './student-nav-bar.component';

describe('StudentNavBarComponent', () => {

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

});
