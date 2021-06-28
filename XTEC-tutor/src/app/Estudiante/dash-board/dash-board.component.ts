import { Component, OnInit } from '@angular/core';
import {FileService} from "../../_service/file.service";

@Component({
  selector: 'app-dash-board',
  templateUrl: './dash-board.component.html',
  styleUrls: ['./dash-board.component.scss']
})
export class DashBoardComponent implements OnInit {

  constructor(private fileService: FileService) { }

  ngOnInit(): void {

  }



}
