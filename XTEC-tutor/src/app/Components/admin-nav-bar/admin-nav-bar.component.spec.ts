import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AdminNavBarComponent } from './admin-nav-bar.component';

describe('AdminNavBarComponent', () => {
  let component: AdminNavBarComponent;
  let fixture: ComponentFixture<AdminNavBarComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AdminNavBarComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AdminNavBarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('Elemento creado', () => {
    expect(component).toBeTruthy();
  });
});
