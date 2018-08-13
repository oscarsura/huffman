public class Node implements Comparable<Node> {
    byte data;
    int value;
    
    Node left;
    Node right;
    
    Node(byte data, int value) {
        this.data = data;
        this.value = value;
        left = null;
        right = null;
    }
    
    public int getKey() {
        return key;
    }
    
    public int getValue() {
        return value;
    }
    
    public int compareTo(Node other) {
        return this.getValue() - other.getValue();
    }
    
    @Override
    public String toString() {
        return String.format("(" + data + ", " + value + ")");
    }
}
