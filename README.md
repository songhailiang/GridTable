# GridTable
Display data in a grid view

# Features
- Easily setup columns and headers (no worries about client change their request to add or remove some columns)
- Support fixed\flexible width column
- Support data type: text, local image, remote image

# Usage
- define grid table columns
```
// Grid Table Columns
let column1 = GridTableColumn(id: .Pos, type: .text, width: .fixed(30), align: .left)
let column2 = GridTableColumn(id: .Arrow, type: .image(CGSize(width: 10, height: 10)), width: .fixed(20))
let column3 = GridTableColumn(id: .Name, type: .text, width: .flexible, align: .left)
let column4 = GridTableColumn(id: .P, type: .text, width: .fixed(30))
let column5 = GridTableColumn(id: .W, type: .text, width: .fixed(30))
```

- define grid table headers
*Note: A Grid Table header might contain multiple columns*
```
// Grid Table Header
let header1 = GridTableColumnHeader(width: .flexible, title: "Pos.", columns: [column1, column2, column3], align: .left)
let header2 = GridTableColumnHeader(width: .fixed(30), title: "P", columns: [column4])
let header3 = GridTableColumnHeader(width: .fixed(30), title: "W", columns: [column5])
```

- initialize grid table object
```
gridTable = GridTable(headers: [header1, header2, header3, header4, header5, header6])
gridTable.delegate = self
```

- add grid table to your view
```
self.view.addSubview(gridTable.view)
```

- implement the delegate method to pass the data to GridTable
```
func gridTable(_ gridTable: GridTable, dataFor row: Int) -> GridTableRowData? {

}
```
Generally, you can extend your data model to implement the ```GridTableRowData``` protocol
```
extension Team: GridTableRowData {
    func data(for column: GridTableColumnId) -> GridTableRowDataType? {
        switch column {
        case .Pos: return .text(pos)
        case .Name: return .text(name)
        case .P: return .text(p)
        case .W: return .text(w)
        case .D: return .text(d)
        case .L: return .text(l)
        case .Pts: return .text(pts)
        case .Arrow:
            if pos == "1" {
                return .image(UIImage(named: "table_arrow_up")!)
            } else if pos == "2" {
                return .image(UIImage(named: "table_arrow_down")!)
            }
            return nil
        default:
            return nil
        }
    }
}
```

That's all!

<img src='https://github.com/songhailiang/GridTable/blob/master/Screenshot.png' width='320' />

