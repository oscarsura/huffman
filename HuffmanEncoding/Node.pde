public class Node implements Comparable<Node> {
    byte data;
    int value;
    
    Node left;
    Node right;
    
    Node() {
        data = 0;
        value = 0;
        left = null;
        right = null;
    }
    
    Node(int value) {
         this.data = 0;
         this.value = value;
         left = null;
         right = null;
    }
    
    Node(byte data, int value) {
        this.data = data;
        this.value = value;
        left = null;
        right = null;
    }
    
    Node(byte data, int value, Node left, Node right) {
        this.data = data;
        this.value = value;
        this.left = left;
        this.right = right;
    }
    
    public int getData() {
        return data;
    }
    
    public int getValue() {
        return value;
    }
    
    public int compareTo(Node other) {
        return this.getValue() - other.getValue();
    }
    
    public Node getLeft() {
        return this.left;
    }
  
    public Node getRight() {
        return this.right;
    }
    
    public void setLeft(Node left) {
        this.left = left;   
    }
    
    public void setRight(Node right) {
        this.right = right;    
    }
    
    @Override
    public String toString() {
        return String.format("(" + this.getData() + ", " + this.getValue() + ")" /*"\n"
        + "left: " + this.getLeft() + "\n"
        + "right: " + this.getRight() + "\n"*/);
    }
}
