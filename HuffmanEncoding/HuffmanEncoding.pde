import java.util.*;

public static final String dataDirectory = "/Users/surao/Desktop/root/dev/github/huffman/data/";
public static final String inputFilepath = dataDirectory + "mobydick.txt";
public static final String outputFilepathBase = dataDirectory;

public void setup() {
    ArrayList<String> lines = new ArrayList<String>(Arrays.asList(loadStrings(inputFilepath)));
    HashMap<Byte, Integer> frequencyMap = buildFrequencyMap(lines);
    PriorityQueue<Node> pqueue = buildQueue(frequencyMap); 
    Node root = buildHuffmanTree(pqueue);
    HashMap<Byte, String> binaryMap = buildBinaryMap(root);
    printBinaryMap(binaryMap);
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

public HashMap<Byte, String> buildBinaryMap(Node node) {
    return buildBinaryMap(node, "");
}

public HashMap<Byte, String> buildBinaryMap(Node node, String encoding) {
    HashMap<Byte, String> binaryMap = new HashMap<Byte, String>();
    if (node != null) {
        if (node.getLeft() == null && node.getRight() == null) {
            binaryMap.put(node.getData(), encoding);   
        }
        
        binaryMap.putAll(buildBinaryMap(node.getLeft(), encoding + "0"));
        binaryMap.putAll(buildBinaryMap(node.getRight(), encoding + "1"));
    }
    return binaryMap;
}

public final static int kEncodingSuccess = 1;
public int encodeData(ArrayList<String> lines) {
    for (String line : lines) {}
    return kEncodingSuccess;
}

public void printBinaryMap(HashMap<Byte, String> map) {
    for(HashMap.Entry<Byte, String> entry : map.entrySet()) {
        Byte b = entry.getKey();
        String s = entry.getValue();
        System.out.println("{" + b + " -> " + s + "}");    
    }
}

public void printFrequencyMap(HashMap<Byte, Integer> map) {
    for (HashMap.Entry<Byte, Integer> entry : map.entrySet()) {
        Byte b = entry.getKey();
        Integer value = entry.getValue();
        System.out.println("{" + b.toString() + ", " + value.toString() + "}");
    }
}

public void printQueue(PriorityQueue<Node> pqueue) {
    Iterator it = pqueue.iterator();
    while (it.hasNext()) {
        System.out.println(it.next().toString());    
    }
}
