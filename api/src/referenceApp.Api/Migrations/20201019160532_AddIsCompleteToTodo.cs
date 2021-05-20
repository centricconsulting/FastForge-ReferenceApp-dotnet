using Microsoft.EntityFrameworkCore.Migrations;

namespace referenceApp.Api.Migrations
{
    public partial class AddIsCompleteToTodo : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsComplete",
                table: "Todos",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsComplete",
                table: "Todos");
        }
    }
}
