import java.util.*;

public static final String dataDirectory = "/Users/surao/Desktop/root/dev/github/huffman/data/mobydick.txt";

public void setup() {
    ArrayList<String> lines = new ArrayList<String>(Arrays.asList(loadStrings(dataDirectory)));
    HashMap<Byte, Integer> frequencyMap = buildFrequencyMap(lines);
    PriorityQueue<Node> pqueue = buildQueue(frequencyMap); 
    Node root = buildHuffmanTree(pqueue);
}

public PriorityQueue<Node> buildQueue(HashMap<Byte, Integer> map) {
    PriorityQueue<Node> pqueue = new PriorityQueue<Node>();
    for(HashMap.Entry<Byte, Integer> entry : map.entrySet()) {
        Node node = new Node(entry.getKey(), entry.getValue());
        pqueue.add(node);
    }
    return pqueue;
}

public Node buildHuffmanTree(PriorityQueue<Node> pqueue) {
    Node root = null;
    while(!pqueue.isEmpty()) {
        Node left = null, right = null;
        int value = 0;
        try {
            left = pqueue.remove();
            right = pqueue.remove();
        } catch (NoSuchElementException e) {}
        
        if (left != null) value += left.getValue();
        if (right != null) value += right.getValue();

        Node parent = new Node(value);
        parent.setLeft(left);
        parent.setRight(right);
        if (pqueue.isEmpty()) {
            return parent;
        } 
        pqueue.add(parent);
        pqueue.remove(left);
        pqueue.remove(right);
    }
    return root;
}

public void printMap(HashMap<Byte, Integer> map) {
    for (HashMap.Entry<Byte, Integer> entry : map.entrySet()) {
        Byte key = entry.getKey();
        Integer value = entry.getValue();
        System.out.println("{" + key.toString() + ", " + value.toString() + "}");
    }
}

public void printQueue(PriorityQueue<Node> pqueue) {
    Iterator it = pqueue.iterator();
    while (it.hasNext()) {
        System.out.println(it.next().toString());    
    }
}

public HashMap<Byte, Integer> buildFrequencyMap(ArrayList<String> lines) {
    HashMap<Byte, Integer> frequencyMap = new HashMap<Byte, Integer>();
    for (String line : lines) {
        try {
            byte[] bytes = line.getBytes("UTF-8");
            for (byte b: bytes) {
                if (frequencyMap.containsKey(b)) {
                    Integer value = frequencyMap.get(b);
                    if (value != null) {
                        frequencyMap.put(b, value+1);
                    }
                } else {
                    frequencyMap.put(b, 1);
                }
            }
        } catch (Exception e) {}
    }
    return frequencyMap;
}
