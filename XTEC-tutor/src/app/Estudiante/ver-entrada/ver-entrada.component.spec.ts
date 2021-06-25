import { ComponentFixture, TestBed } from '@angular/core/testing';

import { VerEntradaComponent } from './ver-entrada.component';

describe('VerEntradaComponent', () => {
  let component: VerEntradaComponent;
  let fixture: ComponentFixture<VerEntradaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ VerEntradaComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(VerEntradaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
