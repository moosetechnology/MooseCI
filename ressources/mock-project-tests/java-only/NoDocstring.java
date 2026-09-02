public class NoDocstring {

    private String name;

    public String getName() {
        return name;
    }

    public void unusedLocalVariable() {
        int a = 1;
        return;
    }
}
