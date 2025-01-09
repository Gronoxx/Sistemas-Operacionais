
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 e4 14 80       	mov    $0x8014e4d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 31 10 80       	mov    $0x801031c0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 78 10 80       	push   $0x80107820
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 75 46 00 00       	call   801046d0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 78 10 80       	push   $0x80107827
80100097:	50                   	push   %eax
80100098:	e8 03 45 00 00       	call   801045a0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 b7 47 00 00       	call   801048a0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 d9 46 00 00       	call   80104840 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 44 00 00       	call   801045e0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 2e 78 10 80       	push   $0x8010782e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 bd 44 00 00       	call   80104680 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 3f 78 10 80       	push   $0x8010783f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 7c 44 00 00       	call   80104680 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 2c 44 00 00       	call   80104640 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 80 46 00 00       	call   801048a0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 cf 45 00 00       	jmp    80104840 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 46 78 10 80       	push   $0x80107846
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 fb 45 00 00       	call   801048a0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 6e 40 00 00       	call   80104340 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 e9 37 00 00       	call   80103ad0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 45 45 00 00       	call   80104840 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 ef 44 00 00       	call   80104840 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 b2 26 00 00       	call   80102a50 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 4d 78 10 80       	push   $0x8010784d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 57 83 10 80 	movl   $0x80108357,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 23 43 00 00       	call   801046f0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 61 78 10 80       	push   $0x80107861
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 91 5d 00 00       	call   801061b0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 a6 5c 00 00       	call   801061b0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 9a 5c 00 00       	call   801061b0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 8e 5c 00 00       	call   801061b0 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 aa 44 00 00       	call   80104a00 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 f5 43 00 00       	call   80104960 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 65 78 10 80       	push   $0x80107865
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 f0 42 00 00       	call   801048a0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 57 42 00 00       	call   80104840 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 90 78 10 80 	movzbl -0x7fef8770(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 b3 40 00 00       	call   801048a0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 78 78 10 80       	mov    $0x80107878,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 e0 3f 00 00       	call   80104840 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 7f 78 10 80       	push   $0x8010787f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 08 40 00 00       	call   801048a0 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 6b 3e 00 00       	call   80104840 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 cd 3a 00 00       	jmp    801044e0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 b7 39 00 00       	call   80104400 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 88 78 10 80       	push   $0x80107888
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 5b 3c 00 00       	call   801046d0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 0f 30 00 00       	call   80103ad0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 f4 23 00 00       	call   80102ec0 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 1c 24 00 00       	call   80102f30 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 97 68 00 00       	call   801073d0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 48 66 00 00       	call   801071f0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 22 65 00 00       	call   80107100 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 30 67 00 00       	call   80107350 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 da 22 00 00       	call   80102f30 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 89 65 00 00       	call   801071f0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 e8 67 00 00       	call   80107470 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 88 3e 00 00       	call   80104b60 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 74 3e 00 00       	call   80104b60 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 43 6a 00 00       	call   80107740 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 3a 66 00 00       	call   80107350 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 d8 69 00 00       	call   80107740 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 7a 3d 00 00       	call   80104b20 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 9e 61 00 00       	call   80106f70 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 76 65 00 00       	call   80107350 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 47 21 00 00       	call   80102f30 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 a1 78 10 80       	push   $0x801078a1
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 ad 78 10 80       	push   $0x801078ad
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 ab 38 00 00       	call   801046d0 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 5a 3a 00 00       	call   801048a0 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 ca 39 00 00       	call   80104840 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 b1 39 00 00       	call   80104840 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 ec 39 00 00       	call   801048a0 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 6f 39 00 00       	call   80104840 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 b4 78 10 80       	push   $0x801078b4
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 9a 39 00 00       	call   801048a0 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 ff 38 00 00       	call   80104840 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 cd 38 00 00       	jmp    80104840 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 43 1f 00 00       	call   80102ec0 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 99 1f 00 00       	jmp    80102f30 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 e2 26 00 00       	call   80103690 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 bc 78 10 80       	push   $0x801078bc
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 9e 27 00 00       	jmp    80103830 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 c6 78 10 80       	push   $0x801078c6
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 22 1e 00 00       	call   80102f30 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 8d 1d 00 00       	call   80102ec0 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 c6 1d 00 00       	call   80102f30 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 cf 78 10 80       	push   $0x801078cf
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 82 25 00 00       	jmp    80103730 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 d5 78 10 80       	push   $0x801078d5
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 8e 1e 00 00       	call   801030a0 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 df 78 10 80       	push   $0x801078df
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 f2 78 10 80       	push   $0x801078f2
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 9e 1d 00 00       	call   801030a0 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 36 36 00 00       	call   80104960 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 6e 1d 00 00       	call   801030a0 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 09 11 80       	push   $0x80110960
8010136a:	e8 31 35 00 00       	call   801048a0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 09 11 80       	push   $0x80110960
801013d7:	e8 64 34 00 00       	call   80104840 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 36 34 00 00       	call   80104840 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 08 79 10 80       	push   $0x80107908
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 d6 1b 00 00       	call   801030a0 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 18 79 10 80       	push   $0x80107918
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 ba 34 00 00       	call   80104a00 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 2b 79 10 80       	push   $0x8010792b
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 55 31 00 00       	call   801046d0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 32 79 10 80       	push   $0x80107932
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 0c 30 00 00       	call   801045a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 25 11 80       	push   $0x801125b4
801015bc:	e8 3f 34 00 00       	call   80104a00 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 25 11 80    	push   0x801125cc
801015cf:	ff 35 c8 25 11 80    	push   0x801125c8
801015d5:	ff 35 c4 25 11 80    	push   0x801125c4
801015db:	ff 35 c0 25 11 80    	push   0x801125c0
801015e1:	ff 35 bc 25 11 80    	push   0x801125bc
801015e7:	ff 35 b8 25 11 80    	push   0x801125b8
801015ed:	ff 35 b4 25 11 80    	push   0x801125b4
801015f3:	68 98 79 10 80       	push   $0x80107998
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 cd 32 00 00       	call   80104960 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 fb 19 00 00       	call   801030a0 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 38 79 10 80       	push   $0x80107938
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 ca 32 00 00       	call   80104a00 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 62 19 00 00       	call   801030a0 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 09 11 80       	push   $0x80110960
8010175f:	e8 3c 31 00 00       	call   801048a0 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 cc 30 00 00       	call   80104840 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 39 2e 00 00       	call   801045e0 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 e3 31 00 00       	call   80104a00 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 50 79 10 80       	push   $0x80107950
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 4a 79 10 80       	push   $0x8010794a
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 08 2e 00 00       	call   80104680 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 ac 2d 00 00       	jmp    80104640 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 5f 79 10 80       	push   $0x8010795f
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 1b 2d 00 00       	call   801045e0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 61 2d 00 00       	call   80104640 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 b5 2f 00 00       	call   801048a0 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 3b 2f 00 00       	jmp    80104840 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 8b 2f 00 00       	call   801048a0 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 1c 2f 00 00       	call   80104840 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 58 2c 00 00       	call   80104680 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 01 2c 00 00       	call   80104640 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 5f 79 10 80       	push   $0x8010795f
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 c4 2e 00 00       	call   80104a00 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 c8 2d 00 00       	call   80104a00 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 60 14 00 00       	call   801030a0 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 9d 2d 00 00       	call   80104a70 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 3e 2d 00 00       	call   80104a70 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 79 79 10 80       	push   $0x80107979
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 67 79 10 80       	push   $0x80107967
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 21 1d 00 00       	call   80103ad0 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 e1 2a 00 00       	call   801048a0 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 71 2a 00 00       	call   80104840 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 d4 2b 00 00       	call   80104a00 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 ef 27 00 00       	call   80104680 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 8d 27 00 00       	call   80104640 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 20 2b 00 00       	call   80104a00 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 50 27 00 00       	call   80104680 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 f1 26 00 00       	call   80104640 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 0e 27 00 00       	call   80104680 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 eb 26 00 00       	call   80104680 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 94 26 00 00       	call   80104640 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 5f 79 10 80       	push   $0x8010795f
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 7e 2a 00 00       	call   80104ac0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 88 79 10 80       	push   $0x80107988
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 ae 80 10 80       	push   $0x801080ae
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 f4 79 10 80       	push   $0x801079f4
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 eb 79 10 80       	push   $0x801079eb
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 06 7a 10 80       	push   $0x80107a06
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 fb 24 00 00       	call   801046d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 a7 14 80       	mov    0x8014a784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 26 11 80       	push   $0x80112600
8010224e:	e8 4d 26 00 00       	call   801048a0 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 4e 21 00 00       	call   80104400 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 26 11 80       	push   $0x80112600
801022cb:	e8 70 25 00 00       	call   80104840 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 8d 23 00 00       	call   80104680 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 26 11 80       	push   $0x80112600
80102328:	e8 73 25 00 00       	call   801048a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 26 11 80       	push   $0x80112600
80102368:	53                   	push   %ebx
80102369:	e8 d2 1f 00 00       	call   80104340 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 b5 24 00 00       	jmp    80104840 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 35 7a 10 80       	push   $0x80107a35
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 20 7a 10 80       	push   $0x80107a20
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 0a 7a 10 80       	push   $0x80107a0a
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 a7 14 80 	movzbl 0x8014a780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 54 7a 10 80       	push   $0x80107a54
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	56                   	push   %esi
801024c4:	53                   	push   %ebx
801024c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024c8:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024ce:	0f 85 a6 00 00 00    	jne    8010257a <kfree+0xba>
801024d4:	81 fb d0 e4 14 80    	cmp    $0x8014e4d0,%ebx
801024da:	0f 82 9a 00 00 00    	jb     8010257a <kfree+0xba>
801024e0:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
801024e6:	81 fe ff ff ff 0d    	cmp    $0xdffffff,%esi
801024ec:	0f 87 88 00 00 00    	ja     8010257a <kfree+0xba>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024f2:	83 ec 04             	sub    $0x4,%esp

  int rcindex = V2P(v) / PGSIZE;
801024f5:	c1 ee 0c             	shr    $0xc,%esi
  memset(v, 1, PGSIZE);
801024f8:	68 00 10 00 00       	push   $0x1000
801024fd:	6a 01                	push   $0x1
801024ff:	53                   	push   %ebx
80102500:	e8 5b 24 00 00       	call   80104960 <memset>
  if(ref_counts[rcindex] > 0)
80102505:	8b 04 b5 40 26 11 80 	mov    -0x7feed9c0(,%esi,4),%eax
8010250c:	83 c4 10             	add    $0x10,%esp
8010250f:	85 c0                	test   %eax,%eax
80102511:	7e 0a                	jle    8010251d <kfree+0x5d>
    ref_counts[rcindex]--;
80102513:	83 e8 01             	sub    $0x1,%eax
80102516:	89 04 b5 40 26 11 80 	mov    %eax,-0x7feed9c0(,%esi,4)
  if(ref_counts[rcindex] == 0){
8010251d:	85 c0                	test   %eax,%eax
8010251f:	75 20                	jne    80102541 <kfree+0x81>
    // free the page
    if(kmem.use_lock)
80102521:	8b 15 74 a6 14 80    	mov    0x8014a674,%edx
80102527:	85 d2                	test   %edx,%edx
80102529:	75 3d                	jne    80102568 <kfree+0xa8>
      acquire(&kmem.lock);
    r = (struct run*)v;
    r->next = kmem.freelist;
8010252b:	a1 78 a6 14 80       	mov    0x8014a678,%eax
80102530:	89 03                	mov    %eax,(%ebx)
    kmem.freelist = r;
    if(kmem.use_lock)
80102532:	a1 74 a6 14 80       	mov    0x8014a674,%eax
    kmem.freelist = r;
80102537:	89 1d 78 a6 14 80    	mov    %ebx,0x8014a678
    if(kmem.use_lock)
8010253d:	85 c0                	test   %eax,%eax
8010253f:	75 0f                	jne    80102550 <kfree+0x90>
      release(&kmem.lock);
  }
}
80102541:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102544:	5b                   	pop    %ebx
80102545:	5e                   	pop    %esi
80102546:	5d                   	pop    %ebp
80102547:	c3                   	ret    
80102548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010254f:	90                   	nop
      release(&kmem.lock);
80102550:	c7 45 08 40 a6 14 80 	movl   $0x8014a640,0x8(%ebp)
}
80102557:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010255a:	5b                   	pop    %ebx
8010255b:	5e                   	pop    %esi
8010255c:	5d                   	pop    %ebp
      release(&kmem.lock);
8010255d:	e9 de 22 00 00       	jmp    80104840 <release>
80102562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&kmem.lock);
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	68 40 a6 14 80       	push   $0x8014a640
80102570:	e8 2b 23 00 00       	call   801048a0 <acquire>
80102575:	83 c4 10             	add    $0x10,%esp
80102578:	eb b1                	jmp    8010252b <kfree+0x6b>
    panic("kfree");
8010257a:	83 ec 0c             	sub    $0xc,%esp
8010257d:	68 86 7a 10 80       	push   $0x80107a86
80102582:	e8 f9 dd ff ff       	call   80100380 <panic>
80102587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010258e:	66 90                	xchg   %ax,%ax

80102590 <freerange>:
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102594:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102597:	8b 75 0c             	mov    0xc(%ebp),%esi
8010259a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010259b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ad:	39 de                	cmp    %ebx,%esi
801025af:	72 23                	jb     801025d4 <freerange+0x44>
801025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 f3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 f3                	cmp    %esi,%ebx
801025d2:	76 e4                	jbe    801025b8 <freerange+0x28>
}
801025d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d7:	5b                   	pop    %ebx
801025d8:	5e                   	pop    %esi
801025d9:	5d                   	pop    %ebp
801025da:	c3                   	ret    
801025db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025df:	90                   	nop

801025e0 <kinit2>:
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025e4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025e7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ea:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025fd:	39 de                	cmp    %ebx,%esi
801025ff:	72 23                	jb     80102624 <kinit2+0x44>
80102601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 a3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <kinit2+0x28>
  kmem.use_lock = 1;
80102624:	c7 05 74 a6 14 80 01 	movl   $0x1,0x8014a674
8010262b:	00 00 00 
}
8010262e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102631:	5b                   	pop    %ebx
80102632:	5e                   	pop    %esi
80102633:	5d                   	pop    %ebp
80102634:	c3                   	ret    
80102635:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102640 <kinit1>:
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	56                   	push   %esi
80102644:	53                   	push   %ebx
80102645:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102648:	83 ec 08             	sub    $0x8,%esp
8010264b:	68 8c 7a 10 80       	push   $0x80107a8c
80102650:	68 40 a6 14 80       	push   $0x8014a640
80102655:	e8 76 20 00 00       	call   801046d0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010265a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010265d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102660:	c7 05 74 a6 14 80 00 	movl   $0x0,0x8014a674
80102667:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010266a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102670:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102676:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010267c:	39 de                	cmp    %ebx,%esi
8010267e:	72 1c                	jb     8010269c <kinit1+0x5c>
    kfree(p);
80102680:	83 ec 0c             	sub    $0xc,%esp
80102683:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102689:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010268f:	50                   	push   %eax
80102690:	e8 2b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102695:	83 c4 10             	add    $0x10,%esp
80102698:	39 de                	cmp    %ebx,%esi
8010269a:	73 e4                	jae    80102680 <kinit1+0x40>
}
8010269c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010269f:	5b                   	pop    %ebx
801026a0:	5e                   	pop    %esi
801026a1:	5d                   	pop    %ebp
801026a2:	c3                   	ret    
801026a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801026b0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801026b0:	a1 74 a6 14 80       	mov    0x8014a674,%eax
801026b5:	85 c0                	test   %eax,%eax
801026b7:	75 2f                	jne    801026e8 <kalloc+0x38>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026b9:	a1 78 a6 14 80       	mov    0x8014a678,%eax
  if(r){
801026be:	85 c0                	test   %eax,%eax
801026c0:	74 1e                	je     801026e0 <kalloc+0x30>
    kmem.freelist = r->next;
801026c2:	8b 10                	mov    (%eax),%edx
801026c4:	89 15 78 a6 14 80    	mov    %edx,0x8014a678
    ref_counts[V2P(r) / PGSIZE] = 1; // initialize refcount
801026ca:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801026d0:	c1 ea 0c             	shr    $0xc,%edx
801026d3:	c7 04 95 40 26 11 80 	movl   $0x1,-0x7feed9c0(,%edx,4)
801026da:	01 00 00 00 
  }
  if(kmem.use_lock)
801026de:	c3                   	ret    
801026df:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026e0:	c3                   	ret    
801026e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026e8:	55                   	push   %ebp
801026e9:	89 e5                	mov    %esp,%ebp
801026eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ee:	68 40 a6 14 80       	push   $0x8014a640
801026f3:	e8 a8 21 00 00       	call   801048a0 <acquire>
  r = kmem.freelist;
801026f8:	a1 78 a6 14 80       	mov    0x8014a678,%eax
  if(kmem.use_lock)
801026fd:	8b 0d 74 a6 14 80    	mov    0x8014a674,%ecx
  if(r){
80102703:	83 c4 10             	add    $0x10,%esp
80102706:	85 c0                	test   %eax,%eax
80102708:	74 1c                	je     80102726 <kalloc+0x76>
    kmem.freelist = r->next;
8010270a:	8b 10                	mov    (%eax),%edx
8010270c:	89 15 78 a6 14 80    	mov    %edx,0x8014a678
    ref_counts[V2P(r) / PGSIZE] = 1; // initialize refcount
80102712:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80102718:	c1 ea 0c             	shr    $0xc,%edx
8010271b:	c7 04 95 40 26 11 80 	movl   $0x1,-0x7feed9c0(,%edx,4)
80102722:	01 00 00 00 
  if(kmem.use_lock)
80102726:	85 c9                	test   %ecx,%ecx
80102728:	74 16                	je     80102740 <kalloc+0x90>
    release(&kmem.lock);
8010272a:	83 ec 0c             	sub    $0xc,%esp
8010272d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102730:	68 40 a6 14 80       	push   $0x8014a640
80102735:	e8 06 21 00 00       	call   80104840 <release>
  return (char*)r;
8010273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
8010273d:	83 c4 10             	add    $0x10,%esp
}
80102740:	c9                   	leave  
80102741:	c3                   	ret    
80102742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102750 <get_ref_count>:


// Function implementations
int get_ref_count(char *pa) {
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
  int index = V2P(pa) / PGSIZE;
80102753:	8b 45 08             	mov    0x8(%ebp),%eax
  return ref_counts[index];
}
80102756:	5d                   	pop    %ebp
  int index = V2P(pa) / PGSIZE;
80102757:	05 00 00 00 80       	add    $0x80000000,%eax
8010275c:	c1 e8 0c             	shr    $0xc,%eax
  return ref_counts[index];
8010275f:	8b 04 85 40 26 11 80 	mov    -0x7feed9c0(,%eax,4),%eax
}
80102766:	c3                   	ret    
80102767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276e:	66 90                	xchg   %ax,%ax

80102770 <decrease_ref_count>:

void decrease_ref_count(char *pa) {
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
  int index = V2P(pa) / PGSIZE;
80102773:	8b 45 08             	mov    0x8(%ebp),%eax
  ref_counts[index]--;
}
80102776:	5d                   	pop    %ebp
  int index = V2P(pa) / PGSIZE;
80102777:	05 00 00 00 80       	add    $0x80000000,%eax
8010277c:	c1 e8 0c             	shr    $0xc,%eax
  ref_counts[index]--;
8010277f:	83 2c 85 40 26 11 80 	subl   $0x1,-0x7feed9c0(,%eax,4)
80102786:	01 
}
80102787:	c3                   	ret    
80102788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278f:	90                   	nop

80102790 <refcount>:

// Reference count functions
int refcount(char *pa) {
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	53                   	push   %ebx
80102794:	83 ec 10             	sub    $0x10,%esp
  acquire(&kmem.lock);
80102797:	68 40 a6 14 80       	push   $0x8014a640
8010279c:	e8 ff 20 00 00       	call   801048a0 <acquire>
  int index = V2P(pa) / PGSIZE;
801027a1:	8b 45 08             	mov    0x8(%ebp),%eax
  int count = get_ref_count(pa);
  release(&kmem.lock);
801027a4:	c7 04 24 40 a6 14 80 	movl   $0x8014a640,(%esp)
  int index = V2P(pa) / PGSIZE;
801027ab:	05 00 00 00 80       	add    $0x80000000,%eax
801027b0:	c1 e8 0c             	shr    $0xc,%eax
  return ref_counts[index];
801027b3:	8b 1c 85 40 26 11 80 	mov    -0x7feed9c0(,%eax,4),%ebx
  release(&kmem.lock);
801027ba:	e8 81 20 00 00       	call   80104840 <release>
  return count;
}
801027bf:	89 d8                	mov    %ebx,%eax
801027c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027c4:	c9                   	leave  
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <decr_ref_count>:

void decr_ref_count(char *pa) {
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	53                   	push   %ebx
801027d4:	83 ec 10             	sub    $0x10,%esp
801027d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&kmem.lock);
801027da:	68 40 a6 14 80       	push   $0x8014a640
801027df:	e8 bc 20 00 00       	call   801048a0 <acquire>
  int index = V2P(pa) / PGSIZE;
801027e4:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  decrease_ref_count(pa);
  release(&kmem.lock);
801027ea:	83 c4 10             	add    $0x10,%esp
}
801027ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  int index = V2P(pa) / PGSIZE;
801027f0:	c1 e8 0c             	shr    $0xc,%eax
  release(&kmem.lock);
801027f3:	c7 45 08 40 a6 14 80 	movl   $0x8014a640,0x8(%ebp)
  ref_counts[index]--;
801027fa:	83 2c 85 40 26 11 80 	subl   $0x1,-0x7feed9c0(,%eax,4)
80102801:	01 
}
80102802:	c9                   	leave  
  release(&kmem.lock);
80102803:	e9 38 20 00 00       	jmp    80104840 <release>
80102808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010280f:	90                   	nop

80102810 <incr_ref_count>:

void incr_ref_count(char *pa) {
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
80102813:	53                   	push   %ebx
80102814:	83 ec 10             	sub    $0x10,%esp
80102817:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&kmem.lock);
8010281a:	68 40 a6 14 80       	push   $0x8014a640
8010281f:	e8 7c 20 00 00       	call   801048a0 <acquire>
  int index = V2P(pa) / PGSIZE;
80102824:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  ref_counts[index]++;
  release(&kmem.lock);
8010282a:	83 c4 10             	add    $0x10,%esp
}
8010282d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  int index = V2P(pa) / PGSIZE;
80102830:	c1 e8 0c             	shr    $0xc,%eax
  release(&kmem.lock);
80102833:	c7 45 08 40 a6 14 80 	movl   $0x8014a640,0x8(%ebp)
  ref_counts[index]++;
8010283a:	83 04 85 40 26 11 80 	addl   $0x1,-0x7feed9c0(,%eax,4)
80102841:	01 
}
80102842:	c9                   	leave  
  release(&kmem.lock);
80102843:	e9 f8 1f 00 00       	jmp    80104840 <release>
80102848:	66 90                	xchg   %ax,%ax
8010284a:	66 90                	xchg   %ax,%ax
8010284c:	66 90                	xchg   %ax,%ax
8010284e:	66 90                	xchg   %ax,%ax

80102850 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102850:	ba 64 00 00 00       	mov    $0x64,%edx
80102855:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102856:	a8 01                	test   $0x1,%al
80102858:	0f 84 c2 00 00 00    	je     80102920 <kbdgetc+0xd0>
{
8010285e:	55                   	push   %ebp
8010285f:	ba 60 00 00 00       	mov    $0x60,%edx
80102864:	89 e5                	mov    %esp,%ebp
80102866:	53                   	push   %ebx
80102867:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102868:	8b 1d 7c a6 14 80    	mov    0x8014a67c,%ebx
  data = inb(KBDATAP);
8010286e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102871:	3c e0                	cmp    $0xe0,%al
80102873:	74 5b                	je     801028d0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102875:	89 da                	mov    %ebx,%edx
80102877:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010287a:	84 c0                	test   %al,%al
8010287c:	78 62                	js     801028e0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010287e:	85 d2                	test   %edx,%edx
80102880:	74 09                	je     8010288b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102882:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102885:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102888:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010288b:	0f b6 91 c0 7b 10 80 	movzbl -0x7fef8440(%ecx),%edx
  shift ^= togglecode[data];
80102892:	0f b6 81 c0 7a 10 80 	movzbl -0x7fef8540(%ecx),%eax
  shift |= shiftcode[data];
80102899:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010289b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010289d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010289f:	89 15 7c a6 14 80    	mov    %edx,0x8014a67c
  c = charcode[shift & (CTL | SHIFT)][data];
801028a5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801028a8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028ab:	8b 04 85 a0 7a 10 80 	mov    -0x7fef8560(,%eax,4),%eax
801028b2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801028b6:	74 0b                	je     801028c3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801028b8:	8d 50 9f             	lea    -0x61(%eax),%edx
801028bb:	83 fa 19             	cmp    $0x19,%edx
801028be:	77 48                	ja     80102908 <kbdgetc+0xb8>
      c += 'A' - 'a';
801028c0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801028c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028c6:	c9                   	leave  
801028c7:	c3                   	ret    
801028c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028cf:	90                   	nop
    shift |= E0ESC;
801028d0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801028d3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801028d5:	89 1d 7c a6 14 80    	mov    %ebx,0x8014a67c
}
801028db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028de:	c9                   	leave  
801028df:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801028e0:	83 e0 7f             	and    $0x7f,%eax
801028e3:	85 d2                	test   %edx,%edx
801028e5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801028e8:	0f b6 81 c0 7b 10 80 	movzbl -0x7fef8440(%ecx),%eax
801028ef:	83 c8 40             	or     $0x40,%eax
801028f2:	0f b6 c0             	movzbl %al,%eax
801028f5:	f7 d0                	not    %eax
801028f7:	21 d8                	and    %ebx,%eax
}
801028f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801028fc:	a3 7c a6 14 80       	mov    %eax,0x8014a67c
    return 0;
80102901:	31 c0                	xor    %eax,%eax
}
80102903:	c9                   	leave  
80102904:	c3                   	ret    
80102905:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102908:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010290b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010290e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102911:	c9                   	leave  
      c += 'a' - 'A';
80102912:	83 f9 1a             	cmp    $0x1a,%ecx
80102915:	0f 42 c2             	cmovb  %edx,%eax
}
80102918:	c3                   	ret    
80102919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102925:	c3                   	ret    
80102926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292d:	8d 76 00             	lea    0x0(%esi),%esi

80102930 <kbdintr>:

void
kbdintr(void)
{
80102930:	55                   	push   %ebp
80102931:	89 e5                	mov    %esp,%ebp
80102933:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102936:	68 50 28 10 80       	push   $0x80102850
8010293b:	e8 40 df ff ff       	call   80100880 <consoleintr>
}
80102940:	83 c4 10             	add    $0x10,%esp
80102943:	c9                   	leave  
80102944:	c3                   	ret    
80102945:	66 90                	xchg   %ax,%ax
80102947:	66 90                	xchg   %ax,%ax
80102949:	66 90                	xchg   %ax,%ax
8010294b:	66 90                	xchg   %ax,%ax
8010294d:	66 90                	xchg   %ax,%ax
8010294f:	90                   	nop

80102950 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102950:	a1 80 a6 14 80       	mov    0x8014a680,%eax
80102955:	85 c0                	test   %eax,%eax
80102957:	0f 84 cb 00 00 00    	je     80102a28 <lapicinit+0xd8>
  lapic[index] = value;
8010295d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102964:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102967:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010296a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102971:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102974:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102977:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010297e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102981:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102984:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010298b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010298e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102991:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102998:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010299b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010299e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801029a5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029a8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801029ab:	8b 50 30             	mov    0x30(%eax),%edx
801029ae:	c1 ea 10             	shr    $0x10,%edx
801029b1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801029b7:	75 77                	jne    80102a30 <lapicinit+0xe0>
  lapic[index] = value;
801029b9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801029c0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029cd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029dd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029e7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ed:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801029f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029fa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a01:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a04:	8b 50 20             	mov    0x20(%eax),%edx
80102a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a0e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a10:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a16:	80 e6 10             	and    $0x10,%dh
80102a19:	75 f5                	jne    80102a10 <lapicinit+0xc0>
  lapic[index] = value;
80102a1b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a22:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a25:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a28:	c3                   	ret    
80102a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102a30:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a37:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a3a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102a3d:	e9 77 ff ff ff       	jmp    801029b9 <lapicinit+0x69>
80102a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a50 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a50:	a1 80 a6 14 80       	mov    0x8014a680,%eax
80102a55:	85 c0                	test   %eax,%eax
80102a57:	74 07                	je     80102a60 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102a59:	8b 40 20             	mov    0x20(%eax),%eax
80102a5c:	c1 e8 18             	shr    $0x18,%eax
80102a5f:	c3                   	ret    
    return 0;
80102a60:	31 c0                	xor    %eax,%eax
}
80102a62:	c3                   	ret    
80102a63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a70 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a70:	a1 80 a6 14 80       	mov    0x8014a680,%eax
80102a75:	85 c0                	test   %eax,%eax
80102a77:	74 0d                	je     80102a86 <lapiceoi+0x16>
  lapic[index] = value;
80102a79:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a80:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a83:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a86:	c3                   	ret    
80102a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a8e:	66 90                	xchg   %ax,%ax

80102a90 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a90:	c3                   	ret    
80102a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a9f:	90                   	nop

80102aa0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102aa0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102aa6:	ba 70 00 00 00       	mov    $0x70,%edx
80102aab:	89 e5                	mov    %esp,%ebp
80102aad:	53                   	push   %ebx
80102aae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ab1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ab4:	ee                   	out    %al,(%dx)
80102ab5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102aba:	ba 71 00 00 00       	mov    $0x71,%edx
80102abf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ac0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102ac2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102ac5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102acb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102acd:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102ad0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102ad2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ad5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102ad8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102ade:	a1 80 a6 14 80       	mov    0x8014a680,%eax
80102ae3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ae9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102aec:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102af3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102af6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102af9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b00:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b03:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b06:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b0c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b0f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b15:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b18:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b1e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b21:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b27:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b2d:	c9                   	leave  
80102b2e:	c3                   	ret    
80102b2f:	90                   	nop

80102b30 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b30:	55                   	push   %ebp
80102b31:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b36:	ba 70 00 00 00       	mov    $0x70,%edx
80102b3b:	89 e5                	mov    %esp,%ebp
80102b3d:	57                   	push   %edi
80102b3e:	56                   	push   %esi
80102b3f:	53                   	push   %ebx
80102b40:	83 ec 4c             	sub    $0x4c,%esp
80102b43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b44:	ba 71 00 00 00       	mov    $0x71,%edx
80102b49:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102b4a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b4d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102b52:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b55:	8d 76 00             	lea    0x0(%esi),%esi
80102b58:	31 c0                	xor    %eax,%eax
80102b5a:	89 da                	mov    %ebx,%edx
80102b5c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b62:	89 ca                	mov    %ecx,%edx
80102b64:	ec                   	in     (%dx),%al
80102b65:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b68:	89 da                	mov    %ebx,%edx
80102b6a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b6f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b70:	89 ca                	mov    %ecx,%edx
80102b72:	ec                   	in     (%dx),%al
80102b73:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b76:	89 da                	mov    %ebx,%edx
80102b78:	b8 04 00 00 00       	mov    $0x4,%eax
80102b7d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b7e:	89 ca                	mov    %ecx,%edx
80102b80:	ec                   	in     (%dx),%al
80102b81:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b84:	89 da                	mov    %ebx,%edx
80102b86:	b8 07 00 00 00       	mov    $0x7,%eax
80102b8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b8c:	89 ca                	mov    %ecx,%edx
80102b8e:	ec                   	in     (%dx),%al
80102b8f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b92:	89 da                	mov    %ebx,%edx
80102b94:	b8 08 00 00 00       	mov    $0x8,%eax
80102b99:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9a:	89 ca                	mov    %ecx,%edx
80102b9c:	ec                   	in     (%dx),%al
80102b9d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b9f:	89 da                	mov    %ebx,%edx
80102ba1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ba6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ba7:	89 ca                	mov    %ecx,%edx
80102ba9:	ec                   	in     (%dx),%al
80102baa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bac:	89 da                	mov    %ebx,%edx
80102bae:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bb3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bb4:	89 ca                	mov    %ecx,%edx
80102bb6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102bb7:	84 c0                	test   %al,%al
80102bb9:	78 9d                	js     80102b58 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102bbb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102bbf:	89 fa                	mov    %edi,%edx
80102bc1:	0f b6 fa             	movzbl %dl,%edi
80102bc4:	89 f2                	mov    %esi,%edx
80102bc6:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102bc9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102bcd:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd0:	89 da                	mov    %ebx,%edx
80102bd2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102bd5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102bd8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102bdc:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102bdf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102be2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102be6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102be9:	31 c0                	xor    %eax,%eax
80102beb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bec:	89 ca                	mov    %ecx,%edx
80102bee:	ec                   	in     (%dx),%al
80102bef:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf2:	89 da                	mov    %ebx,%edx
80102bf4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102bf7:	b8 02 00 00 00       	mov    $0x2,%eax
80102bfc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfd:	89 ca                	mov    %ecx,%edx
80102bff:	ec                   	in     (%dx),%al
80102c00:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c03:	89 da                	mov    %ebx,%edx
80102c05:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c08:	b8 04 00 00 00       	mov    $0x4,%eax
80102c0d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0e:	89 ca                	mov    %ecx,%edx
80102c10:	ec                   	in     (%dx),%al
80102c11:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c14:	89 da                	mov    %ebx,%edx
80102c16:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c19:	b8 07 00 00 00       	mov    $0x7,%eax
80102c1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1f:	89 ca                	mov    %ecx,%edx
80102c21:	ec                   	in     (%dx),%al
80102c22:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c25:	89 da                	mov    %ebx,%edx
80102c27:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c2a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c2f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c30:	89 ca                	mov    %ecx,%edx
80102c32:	ec                   	in     (%dx),%al
80102c33:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c36:	89 da                	mov    %ebx,%edx
80102c38:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c3b:	b8 09 00 00 00       	mov    $0x9,%eax
80102c40:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c41:	89 ca                	mov    %ecx,%edx
80102c43:	ec                   	in     (%dx),%al
80102c44:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c47:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c4d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c50:	6a 18                	push   $0x18
80102c52:	50                   	push   %eax
80102c53:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c56:	50                   	push   %eax
80102c57:	e8 54 1d 00 00       	call   801049b0 <memcmp>
80102c5c:	83 c4 10             	add    $0x10,%esp
80102c5f:	85 c0                	test   %eax,%eax
80102c61:	0f 85 f1 fe ff ff    	jne    80102b58 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102c67:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102c6b:	75 78                	jne    80102ce5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c6d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c70:	89 c2                	mov    %eax,%edx
80102c72:	83 e0 0f             	and    $0xf,%eax
80102c75:	c1 ea 04             	shr    $0x4,%edx
80102c78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c7e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c81:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c84:	89 c2                	mov    %eax,%edx
80102c86:	83 e0 0f             	and    $0xf,%eax
80102c89:	c1 ea 04             	shr    $0x4,%edx
80102c8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c92:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c95:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c98:	89 c2                	mov    %eax,%edx
80102c9a:	83 e0 0f             	and    $0xf,%eax
80102c9d:	c1 ea 04             	shr    $0x4,%edx
80102ca0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ca3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ca6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ca9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cac:	89 c2                	mov    %eax,%edx
80102cae:	83 e0 0f             	and    $0xf,%eax
80102cb1:	c1 ea 04             	shr    $0x4,%edx
80102cb4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cb7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102cbd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cc0:	89 c2                	mov    %eax,%edx
80102cc2:	83 e0 0f             	and    $0xf,%eax
80102cc5:	c1 ea 04             	shr    $0x4,%edx
80102cc8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ccb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cce:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102cd1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cd4:	89 c2                	mov    %eax,%edx
80102cd6:	83 e0 0f             	and    $0xf,%eax
80102cd9:	c1 ea 04             	shr    $0x4,%edx
80102cdc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cdf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ce2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ce5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ce8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ceb:	89 06                	mov    %eax,(%esi)
80102ced:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cf0:	89 46 04             	mov    %eax,0x4(%esi)
80102cf3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cf6:	89 46 08             	mov    %eax,0x8(%esi)
80102cf9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cfc:	89 46 0c             	mov    %eax,0xc(%esi)
80102cff:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d02:	89 46 10             	mov    %eax,0x10(%esi)
80102d05:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d08:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d0b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d15:	5b                   	pop    %ebx
80102d16:	5e                   	pop    %esi
80102d17:	5f                   	pop    %edi
80102d18:	5d                   	pop    %ebp
80102d19:	c3                   	ret    
80102d1a:	66 90                	xchg   %ax,%ax
80102d1c:	66 90                	xchg   %ax,%ax
80102d1e:	66 90                	xchg   %ax,%ax

80102d20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d20:	8b 0d e8 a6 14 80    	mov    0x8014a6e8,%ecx
80102d26:	85 c9                	test   %ecx,%ecx
80102d28:	0f 8e 8a 00 00 00    	jle    80102db8 <install_trans+0x98>
{
80102d2e:	55                   	push   %ebp
80102d2f:	89 e5                	mov    %esp,%ebp
80102d31:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102d32:	31 ff                	xor    %edi,%edi
{
80102d34:	56                   	push   %esi
80102d35:	53                   	push   %ebx
80102d36:	83 ec 0c             	sub    $0xc,%esp
80102d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d40:	a1 d4 a6 14 80       	mov    0x8014a6d4,%eax
80102d45:	83 ec 08             	sub    $0x8,%esp
80102d48:	01 f8                	add    %edi,%eax
80102d4a:	83 c0 01             	add    $0x1,%eax
80102d4d:	50                   	push   %eax
80102d4e:	ff 35 e4 a6 14 80    	push   0x8014a6e4
80102d54:	e8 77 d3 ff ff       	call   801000d0 <bread>
80102d59:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d5b:	58                   	pop    %eax
80102d5c:	5a                   	pop    %edx
80102d5d:	ff 34 bd ec a6 14 80 	push   -0x7feb5914(,%edi,4)
80102d64:	ff 35 e4 a6 14 80    	push   0x8014a6e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d6a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d6d:	e8 5e d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d72:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d75:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d77:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d7a:	68 00 02 00 00       	push   $0x200
80102d7f:	50                   	push   %eax
80102d80:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102d83:	50                   	push   %eax
80102d84:	e8 77 1c 00 00       	call   80104a00 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d89:	89 1c 24             	mov    %ebx,(%esp)
80102d8c:	e8 1f d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102d91:	89 34 24             	mov    %esi,(%esp)
80102d94:	e8 57 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102d99:	89 1c 24             	mov    %ebx,(%esp)
80102d9c:	e8 4f d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102da1:	83 c4 10             	add    $0x10,%esp
80102da4:	39 3d e8 a6 14 80    	cmp    %edi,0x8014a6e8
80102daa:	7f 94                	jg     80102d40 <install_trans+0x20>
  }
}
80102dac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102daf:	5b                   	pop    %ebx
80102db0:	5e                   	pop    %esi
80102db1:	5f                   	pop    %edi
80102db2:	5d                   	pop    %ebp
80102db3:	c3                   	ret    
80102db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102db8:	c3                   	ret    
80102db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102dc0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	53                   	push   %ebx
80102dc4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102dc7:	ff 35 d4 a6 14 80    	push   0x8014a6d4
80102dcd:	ff 35 e4 a6 14 80    	push   0x8014a6e4
80102dd3:	e8 f8 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102dd8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ddb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102ddd:	a1 e8 a6 14 80       	mov    0x8014a6e8,%eax
80102de2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102de5:	85 c0                	test   %eax,%eax
80102de7:	7e 19                	jle    80102e02 <write_head+0x42>
80102de9:	31 d2                	xor    %edx,%edx
80102deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102def:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102df0:	8b 0c 95 ec a6 14 80 	mov    -0x7feb5914(,%edx,4),%ecx
80102df7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102dfb:	83 c2 01             	add    $0x1,%edx
80102dfe:	39 d0                	cmp    %edx,%eax
80102e00:	75 ee                	jne    80102df0 <write_head+0x30>
  }
  bwrite(buf);
80102e02:	83 ec 0c             	sub    $0xc,%esp
80102e05:	53                   	push   %ebx
80102e06:	e8 a5 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102e0b:	89 1c 24             	mov    %ebx,(%esp)
80102e0e:	e8 dd d3 ff ff       	call   801001f0 <brelse>
}
80102e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e16:	83 c4 10             	add    $0x10,%esp
80102e19:	c9                   	leave  
80102e1a:	c3                   	ret    
80102e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e1f:	90                   	nop

80102e20 <initlog>:
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	53                   	push   %ebx
80102e24:	83 ec 2c             	sub    $0x2c,%esp
80102e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e2a:	68 c0 7c 10 80       	push   $0x80107cc0
80102e2f:	68 a0 a6 14 80       	push   $0x8014a6a0
80102e34:	e8 97 18 00 00       	call   801046d0 <initlock>
  readsb(dev, &sb);
80102e39:	58                   	pop    %eax
80102e3a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e3d:	5a                   	pop    %edx
80102e3e:	50                   	push   %eax
80102e3f:	53                   	push   %ebx
80102e40:	e8 db e6 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102e45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e48:	59                   	pop    %ecx
  log.dev = dev;
80102e49:	89 1d e4 a6 14 80    	mov    %ebx,0x8014a6e4
  log.size = sb.nlog;
80102e4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e52:	a3 d4 a6 14 80       	mov    %eax,0x8014a6d4
  log.size = sb.nlog;
80102e57:	89 15 d8 a6 14 80    	mov    %edx,0x8014a6d8
  struct buf *buf = bread(log.dev, log.start);
80102e5d:	5a                   	pop    %edx
80102e5e:	50                   	push   %eax
80102e5f:	53                   	push   %ebx
80102e60:	e8 6b d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102e65:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102e68:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102e6b:	89 1d e8 a6 14 80    	mov    %ebx,0x8014a6e8
  for (i = 0; i < log.lh.n; i++) {
80102e71:	85 db                	test   %ebx,%ebx
80102e73:	7e 1d                	jle    80102e92 <initlog+0x72>
80102e75:	31 d2                	xor    %edx,%edx
80102e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e7e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102e80:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102e84:	89 0c 95 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e8b:	83 c2 01             	add    $0x1,%edx
80102e8e:	39 d3                	cmp    %edx,%ebx
80102e90:	75 ee                	jne    80102e80 <initlog+0x60>
  brelse(buf);
80102e92:	83 ec 0c             	sub    $0xc,%esp
80102e95:	50                   	push   %eax
80102e96:	e8 55 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e9b:	e8 80 fe ff ff       	call   80102d20 <install_trans>
  log.lh.n = 0;
80102ea0:	c7 05 e8 a6 14 80 00 	movl   $0x0,0x8014a6e8
80102ea7:	00 00 00 
  write_head(); // clear the log
80102eaa:	e8 11 ff ff ff       	call   80102dc0 <write_head>
}
80102eaf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102eb2:	83 c4 10             	add    $0x10,%esp
80102eb5:	c9                   	leave  
80102eb6:	c3                   	ret    
80102eb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ebe:	66 90                	xchg   %ax,%ax

80102ec0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ec6:	68 a0 a6 14 80       	push   $0x8014a6a0
80102ecb:	e8 d0 19 00 00       	call   801048a0 <acquire>
80102ed0:	83 c4 10             	add    $0x10,%esp
80102ed3:	eb 18                	jmp    80102eed <begin_op+0x2d>
80102ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ed8:	83 ec 08             	sub    $0x8,%esp
80102edb:	68 a0 a6 14 80       	push   $0x8014a6a0
80102ee0:	68 a0 a6 14 80       	push   $0x8014a6a0
80102ee5:	e8 56 14 00 00       	call   80104340 <sleep>
80102eea:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102eed:	a1 e0 a6 14 80       	mov    0x8014a6e0,%eax
80102ef2:	85 c0                	test   %eax,%eax
80102ef4:	75 e2                	jne    80102ed8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ef6:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
80102efb:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
80102f01:	83 c0 01             	add    $0x1,%eax
80102f04:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f07:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f0a:	83 fa 1e             	cmp    $0x1e,%edx
80102f0d:	7f c9                	jg     80102ed8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f0f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f12:	a3 dc a6 14 80       	mov    %eax,0x8014a6dc
      release(&log.lock);
80102f17:	68 a0 a6 14 80       	push   $0x8014a6a0
80102f1c:	e8 1f 19 00 00       	call   80104840 <release>
      break;
    }
  }
}
80102f21:	83 c4 10             	add    $0x10,%esp
80102f24:	c9                   	leave  
80102f25:	c3                   	ret    
80102f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f2d:	8d 76 00             	lea    0x0(%esi),%esi

80102f30 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f30:	55                   	push   %ebp
80102f31:	89 e5                	mov    %esp,%ebp
80102f33:	57                   	push   %edi
80102f34:	56                   	push   %esi
80102f35:	53                   	push   %ebx
80102f36:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f39:	68 a0 a6 14 80       	push   $0x8014a6a0
80102f3e:	e8 5d 19 00 00       	call   801048a0 <acquire>
  log.outstanding -= 1;
80102f43:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
  if(log.committing)
80102f48:	8b 35 e0 a6 14 80    	mov    0x8014a6e0,%esi
80102f4e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f51:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102f54:	89 1d dc a6 14 80    	mov    %ebx,0x8014a6dc
  if(log.committing)
80102f5a:	85 f6                	test   %esi,%esi
80102f5c:	0f 85 22 01 00 00    	jne    80103084 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f62:	85 db                	test   %ebx,%ebx
80102f64:	0f 85 f6 00 00 00    	jne    80103060 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102f6a:	c7 05 e0 a6 14 80 01 	movl   $0x1,0x8014a6e0
80102f71:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f74:	83 ec 0c             	sub    $0xc,%esp
80102f77:	68 a0 a6 14 80       	push   $0x8014a6a0
80102f7c:	e8 bf 18 00 00       	call   80104840 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f81:	8b 0d e8 a6 14 80    	mov    0x8014a6e8,%ecx
80102f87:	83 c4 10             	add    $0x10,%esp
80102f8a:	85 c9                	test   %ecx,%ecx
80102f8c:	7f 42                	jg     80102fd0 <end_op+0xa0>
    acquire(&log.lock);
80102f8e:	83 ec 0c             	sub    $0xc,%esp
80102f91:	68 a0 a6 14 80       	push   $0x8014a6a0
80102f96:	e8 05 19 00 00       	call   801048a0 <acquire>
    wakeup(&log);
80102f9b:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
    log.committing = 0;
80102fa2:	c7 05 e0 a6 14 80 00 	movl   $0x0,0x8014a6e0
80102fa9:	00 00 00 
    wakeup(&log);
80102fac:	e8 4f 14 00 00       	call   80104400 <wakeup>
    release(&log.lock);
80102fb1:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
80102fb8:	e8 83 18 00 00       	call   80104840 <release>
80102fbd:	83 c4 10             	add    $0x10,%esp
}
80102fc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fc3:	5b                   	pop    %ebx
80102fc4:	5e                   	pop    %esi
80102fc5:	5f                   	pop    %edi
80102fc6:	5d                   	pop    %ebp
80102fc7:	c3                   	ret    
80102fc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fcf:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102fd0:	a1 d4 a6 14 80       	mov    0x8014a6d4,%eax
80102fd5:	83 ec 08             	sub    $0x8,%esp
80102fd8:	01 d8                	add    %ebx,%eax
80102fda:	83 c0 01             	add    $0x1,%eax
80102fdd:	50                   	push   %eax
80102fde:	ff 35 e4 a6 14 80    	push   0x8014a6e4
80102fe4:	e8 e7 d0 ff ff       	call   801000d0 <bread>
80102fe9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102feb:	58                   	pop    %eax
80102fec:	5a                   	pop    %edx
80102fed:	ff 34 9d ec a6 14 80 	push   -0x7feb5914(,%ebx,4)
80102ff4:	ff 35 e4 a6 14 80    	push   0x8014a6e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102ffa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ffd:	e8 ce d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103002:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103005:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103007:	8d 40 5c             	lea    0x5c(%eax),%eax
8010300a:	68 00 02 00 00       	push   $0x200
8010300f:	50                   	push   %eax
80103010:	8d 46 5c             	lea    0x5c(%esi),%eax
80103013:	50                   	push   %eax
80103014:	e8 e7 19 00 00       	call   80104a00 <memmove>
    bwrite(to);  // write the log
80103019:	89 34 24             	mov    %esi,(%esp)
8010301c:	e8 8f d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103021:	89 3c 24             	mov    %edi,(%esp)
80103024:	e8 c7 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103029:	89 34 24             	mov    %esi,(%esp)
8010302c:	e8 bf d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103031:	83 c4 10             	add    $0x10,%esp
80103034:	3b 1d e8 a6 14 80    	cmp    0x8014a6e8,%ebx
8010303a:	7c 94                	jl     80102fd0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010303c:	e8 7f fd ff ff       	call   80102dc0 <write_head>
    install_trans(); // Now install writes to home locations
80103041:	e8 da fc ff ff       	call   80102d20 <install_trans>
    log.lh.n = 0;
80103046:	c7 05 e8 a6 14 80 00 	movl   $0x0,0x8014a6e8
8010304d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103050:	e8 6b fd ff ff       	call   80102dc0 <write_head>
80103055:	e9 34 ff ff ff       	jmp    80102f8e <end_op+0x5e>
8010305a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103060:	83 ec 0c             	sub    $0xc,%esp
80103063:	68 a0 a6 14 80       	push   $0x8014a6a0
80103068:	e8 93 13 00 00       	call   80104400 <wakeup>
  release(&log.lock);
8010306d:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
80103074:	e8 c7 17 00 00       	call   80104840 <release>
80103079:	83 c4 10             	add    $0x10,%esp
}
8010307c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010307f:	5b                   	pop    %ebx
80103080:	5e                   	pop    %esi
80103081:	5f                   	pop    %edi
80103082:	5d                   	pop    %ebp
80103083:	c3                   	ret    
    panic("log.committing");
80103084:	83 ec 0c             	sub    $0xc,%esp
80103087:	68 c4 7c 10 80       	push   $0x80107cc4
8010308c:	e8 ef d2 ff ff       	call   80100380 <panic>
80103091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010309f:	90                   	nop

801030a0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	53                   	push   %ebx
801030a4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030a7:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
{
801030ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030b0:	83 fa 1d             	cmp    $0x1d,%edx
801030b3:	0f 8f 85 00 00 00    	jg     8010313e <log_write+0x9e>
801030b9:	a1 d8 a6 14 80       	mov    0x8014a6d8,%eax
801030be:	83 e8 01             	sub    $0x1,%eax
801030c1:	39 c2                	cmp    %eax,%edx
801030c3:	7d 79                	jge    8010313e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
801030c5:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
801030ca:	85 c0                	test   %eax,%eax
801030cc:	7e 7d                	jle    8010314b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
801030ce:	83 ec 0c             	sub    $0xc,%esp
801030d1:	68 a0 a6 14 80       	push   $0x8014a6a0
801030d6:	e8 c5 17 00 00       	call   801048a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801030db:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
801030e1:	83 c4 10             	add    $0x10,%esp
801030e4:	85 d2                	test   %edx,%edx
801030e6:	7e 4a                	jle    80103132 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030e8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801030eb:	31 c0                	xor    %eax,%eax
801030ed:	eb 08                	jmp    801030f7 <log_write+0x57>
801030ef:	90                   	nop
801030f0:	83 c0 01             	add    $0x1,%eax
801030f3:	39 c2                	cmp    %eax,%edx
801030f5:	74 29                	je     80103120 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030f7:	39 0c 85 ec a6 14 80 	cmp    %ecx,-0x7feb5914(,%eax,4)
801030fe:	75 f0                	jne    801030f0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103100:	89 0c 85 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103107:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010310a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010310d:	c7 45 08 a0 a6 14 80 	movl   $0x8014a6a0,0x8(%ebp)
}
80103114:	c9                   	leave  
  release(&log.lock);
80103115:	e9 26 17 00 00       	jmp    80104840 <release>
8010311a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103120:	89 0c 95 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%edx,4)
    log.lh.n++;
80103127:	83 c2 01             	add    $0x1,%edx
8010312a:	89 15 e8 a6 14 80    	mov    %edx,0x8014a6e8
80103130:	eb d5                	jmp    80103107 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103132:	8b 43 08             	mov    0x8(%ebx),%eax
80103135:	a3 ec a6 14 80       	mov    %eax,0x8014a6ec
  if (i == log.lh.n)
8010313a:	75 cb                	jne    80103107 <log_write+0x67>
8010313c:	eb e9                	jmp    80103127 <log_write+0x87>
    panic("too big a transaction");
8010313e:	83 ec 0c             	sub    $0xc,%esp
80103141:	68 d3 7c 10 80       	push   $0x80107cd3
80103146:	e8 35 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010314b:	83 ec 0c             	sub    $0xc,%esp
8010314e:	68 e9 7c 10 80       	push   $0x80107ce9
80103153:	e8 28 d2 ff ff       	call   80100380 <panic>
80103158:	66 90                	xchg   %ax,%ax
8010315a:	66 90                	xchg   %ax,%ax
8010315c:	66 90                	xchg   %ax,%ax
8010315e:	66 90                	xchg   %ax,%ax

80103160 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	53                   	push   %ebx
80103164:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103167:	e8 44 09 00 00       	call   80103ab0 <cpuid>
8010316c:	89 c3                	mov    %eax,%ebx
8010316e:	e8 3d 09 00 00       	call   80103ab0 <cpuid>
80103173:	83 ec 04             	sub    $0x4,%esp
80103176:	53                   	push   %ebx
80103177:	50                   	push   %eax
80103178:	68 04 7d 10 80       	push   $0x80107d04
8010317d:	e8 1e d5 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103182:	e8 69 2b 00 00       	call   80105cf0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103187:	e8 c4 08 00 00       	call   80103a50 <mycpu>
8010318c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010318e:	b8 01 00 00 00       	mov    $0x1,%eax
80103193:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010319a:	e8 91 0d 00 00       	call   80103f30 <scheduler>
8010319f:	90                   	nop

801031a0 <mpenter>:
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801031a6:	e8 b5 3d 00 00       	call   80106f60 <switchkvm>
  seginit();
801031ab:	e8 90 3c 00 00       	call   80106e40 <seginit>
  lapicinit();
801031b0:	e8 9b f7 ff ff       	call   80102950 <lapicinit>
  mpmain();
801031b5:	e8 a6 ff ff ff       	call   80103160 <mpmain>
801031ba:	66 90                	xchg   %ax,%ax
801031bc:	66 90                	xchg   %ax,%ax
801031be:	66 90                	xchg   %ax,%ax

801031c0 <main>:
{
801031c0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801031c4:	83 e4 f0             	and    $0xfffffff0,%esp
801031c7:	ff 71 fc             	push   -0x4(%ecx)
801031ca:	55                   	push   %ebp
801031cb:	89 e5                	mov    %esp,%ebp
801031cd:	53                   	push   %ebx
801031ce:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801031cf:	83 ec 08             	sub    $0x8,%esp
801031d2:	68 00 00 40 80       	push   $0x80400000
801031d7:	68 d0 e4 14 80       	push   $0x8014e4d0
801031dc:	e8 5f f4 ff ff       	call   80102640 <kinit1>
  kvmalloc();      // kernel page table
801031e1:	e8 6a 42 00 00       	call   80107450 <kvmalloc>
  mpinit();        // detect other processors
801031e6:	e8 85 01 00 00       	call   80103370 <mpinit>
  lapicinit();     // interrupt controller
801031eb:	e8 60 f7 ff ff       	call   80102950 <lapicinit>
  seginit();       // segment descriptors
801031f0:	e8 4b 3c 00 00       	call   80106e40 <seginit>
  picinit();       // disable pic
801031f5:	e8 76 03 00 00       	call   80103570 <picinit>
  ioapicinit();    // another interrupt controller
801031fa:	e8 d1 f1 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
801031ff:	e8 5c d8 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103204:	e8 c7 2e 00 00       	call   801060d0 <uartinit>
  pinit();         // process table
80103209:	e8 22 08 00 00       	call   80103a30 <pinit>
  tvinit();        // trap vectors
8010320e:	e8 5d 2a 00 00       	call   80105c70 <tvinit>
  binit();         // buffer cache
80103213:	e8 28 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103218:	e8 f3 db ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
8010321d:	e8 9e ef ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103222:	83 c4 0c             	add    $0xc,%esp
80103225:	68 8a 00 00 00       	push   $0x8a
8010322a:	68 8c b4 10 80       	push   $0x8010b48c
8010322f:	68 00 70 00 80       	push   $0x80007000
80103234:	e8 c7 17 00 00       	call   80104a00 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103239:	83 c4 10             	add    $0x10,%esp
8010323c:	69 05 84 a7 14 80 b0 	imul   $0xb0,0x8014a784,%eax
80103243:	00 00 00 
80103246:	05 a0 a7 14 80       	add    $0x8014a7a0,%eax
8010324b:	3d a0 a7 14 80       	cmp    $0x8014a7a0,%eax
80103250:	76 7e                	jbe    801032d0 <main+0x110>
80103252:	bb a0 a7 14 80       	mov    $0x8014a7a0,%ebx
80103257:	eb 20                	jmp    80103279 <main+0xb9>
80103259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103260:	69 05 84 a7 14 80 b0 	imul   $0xb0,0x8014a784,%eax
80103267:	00 00 00 
8010326a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103270:	05 a0 a7 14 80       	add    $0x8014a7a0,%eax
80103275:	39 c3                	cmp    %eax,%ebx
80103277:	73 57                	jae    801032d0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103279:	e8 d2 07 00 00       	call   80103a50 <mycpu>
8010327e:	39 c3                	cmp    %eax,%ebx
80103280:	74 de                	je     80103260 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103282:	e8 29 f4 ff ff       	call   801026b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103287:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010328a:	c7 05 f8 6f 00 80 a0 	movl   $0x801031a0,0x80006ff8
80103291:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103294:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010329b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010329e:	05 00 10 00 00       	add    $0x1000,%eax
801032a3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801032a8:	0f b6 03             	movzbl (%ebx),%eax
801032ab:	68 00 70 00 00       	push   $0x7000
801032b0:	50                   	push   %eax
801032b1:	e8 ea f7 ff ff       	call   80102aa0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801032b6:	83 c4 10             	add    $0x10,%esp
801032b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801032c6:	85 c0                	test   %eax,%eax
801032c8:	74 f6                	je     801032c0 <main+0x100>
801032ca:	eb 94                	jmp    80103260 <main+0xa0>
801032cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801032d0:	83 ec 08             	sub    $0x8,%esp
801032d3:	68 00 00 00 8e       	push   $0x8e000000
801032d8:	68 00 00 40 80       	push   $0x80400000
801032dd:	e8 fe f2 ff ff       	call   801025e0 <kinit2>
  userinit();      // first user process
801032e2:	e8 19 08 00 00       	call   80103b00 <userinit>
  mpmain();        // finish this processor's setup
801032e7:	e8 74 fe ff ff       	call   80103160 <mpmain>
801032ec:	66 90                	xchg   %ax,%ax
801032ee:	66 90                	xchg   %ax,%ax

801032f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	57                   	push   %edi
801032f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801032f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801032fb:	53                   	push   %ebx
  e = addr+len;
801032fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801032ff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103302:	39 de                	cmp    %ebx,%esi
80103304:	72 10                	jb     80103316 <mpsearch1+0x26>
80103306:	eb 50                	jmp    80103358 <mpsearch1+0x68>
80103308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010330f:	90                   	nop
80103310:	89 fe                	mov    %edi,%esi
80103312:	39 fb                	cmp    %edi,%ebx
80103314:	76 42                	jbe    80103358 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103316:	83 ec 04             	sub    $0x4,%esp
80103319:	8d 7e 10             	lea    0x10(%esi),%edi
8010331c:	6a 04                	push   $0x4
8010331e:	68 18 7d 10 80       	push   $0x80107d18
80103323:	56                   	push   %esi
80103324:	e8 87 16 00 00       	call   801049b0 <memcmp>
80103329:	83 c4 10             	add    $0x10,%esp
8010332c:	85 c0                	test   %eax,%eax
8010332e:	75 e0                	jne    80103310 <mpsearch1+0x20>
80103330:	89 f2                	mov    %esi,%edx
80103332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103338:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010333b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010333e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103340:	39 fa                	cmp    %edi,%edx
80103342:	75 f4                	jne    80103338 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103344:	84 c0                	test   %al,%al
80103346:	75 c8                	jne    80103310 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103348:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010334b:	89 f0                	mov    %esi,%eax
8010334d:	5b                   	pop    %ebx
8010334e:	5e                   	pop    %esi
8010334f:	5f                   	pop    %edi
80103350:	5d                   	pop    %ebp
80103351:	c3                   	ret    
80103352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103358:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010335b:	31 f6                	xor    %esi,%esi
}
8010335d:	5b                   	pop    %ebx
8010335e:	89 f0                	mov    %esi,%eax
80103360:	5e                   	pop    %esi
80103361:	5f                   	pop    %edi
80103362:	5d                   	pop    %ebp
80103363:	c3                   	ret    
80103364:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010336b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010336f:	90                   	nop

80103370 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103370:	55                   	push   %ebp
80103371:	89 e5                	mov    %esp,%ebp
80103373:	57                   	push   %edi
80103374:	56                   	push   %esi
80103375:	53                   	push   %ebx
80103376:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103379:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103380:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103387:	c1 e0 08             	shl    $0x8,%eax
8010338a:	09 d0                	or     %edx,%eax
8010338c:	c1 e0 04             	shl    $0x4,%eax
8010338f:	75 1b                	jne    801033ac <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103391:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103398:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010339f:	c1 e0 08             	shl    $0x8,%eax
801033a2:	09 d0                	or     %edx,%eax
801033a4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801033a7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801033ac:	ba 00 04 00 00       	mov    $0x400,%edx
801033b1:	e8 3a ff ff ff       	call   801032f0 <mpsearch1>
801033b6:	89 c3                	mov    %eax,%ebx
801033b8:	85 c0                	test   %eax,%eax
801033ba:	0f 84 40 01 00 00    	je     80103500 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033c0:	8b 73 04             	mov    0x4(%ebx),%esi
801033c3:	85 f6                	test   %esi,%esi
801033c5:	0f 84 25 01 00 00    	je     801034f0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
801033cb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033ce:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801033d4:	6a 04                	push   $0x4
801033d6:	68 1d 7d 10 80       	push   $0x80107d1d
801033db:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801033df:	e8 cc 15 00 00       	call   801049b0 <memcmp>
801033e4:	83 c4 10             	add    $0x10,%esp
801033e7:	85 c0                	test   %eax,%eax
801033e9:	0f 85 01 01 00 00    	jne    801034f0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801033ef:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801033f6:	3c 01                	cmp    $0x1,%al
801033f8:	74 08                	je     80103402 <mpinit+0x92>
801033fa:	3c 04                	cmp    $0x4,%al
801033fc:	0f 85 ee 00 00 00    	jne    801034f0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103402:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103409:	66 85 d2             	test   %dx,%dx
8010340c:	74 22                	je     80103430 <mpinit+0xc0>
8010340e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103411:	89 f0                	mov    %esi,%eax
  sum = 0;
80103413:	31 d2                	xor    %edx,%edx
80103415:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103418:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010341f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103422:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103424:	39 c7                	cmp    %eax,%edi
80103426:	75 f0                	jne    80103418 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103428:	84 d2                	test   %dl,%dl
8010342a:	0f 85 c0 00 00 00    	jne    801034f0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103430:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103436:	a3 80 a6 14 80       	mov    %eax,0x8014a680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010343b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103442:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103448:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010344d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103450:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103457:	90                   	nop
80103458:	39 d0                	cmp    %edx,%eax
8010345a:	73 15                	jae    80103471 <mpinit+0x101>
    switch(*p){
8010345c:	0f b6 08             	movzbl (%eax),%ecx
8010345f:	80 f9 02             	cmp    $0x2,%cl
80103462:	74 4c                	je     801034b0 <mpinit+0x140>
80103464:	77 3a                	ja     801034a0 <mpinit+0x130>
80103466:	84 c9                	test   %cl,%cl
80103468:	74 56                	je     801034c0 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010346a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010346d:	39 d0                	cmp    %edx,%eax
8010346f:	72 eb                	jb     8010345c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103471:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103474:	85 f6                	test   %esi,%esi
80103476:	0f 84 d9 00 00 00    	je     80103555 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010347c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103480:	74 15                	je     80103497 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103482:	b8 70 00 00 00       	mov    $0x70,%eax
80103487:	ba 22 00 00 00       	mov    $0x22,%edx
8010348c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010348d:	ba 23 00 00 00       	mov    $0x23,%edx
80103492:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103493:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103496:	ee                   	out    %al,(%dx)
  }
}
80103497:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010349a:	5b                   	pop    %ebx
8010349b:	5e                   	pop    %esi
8010349c:	5f                   	pop    %edi
8010349d:	5d                   	pop    %ebp
8010349e:	c3                   	ret    
8010349f:	90                   	nop
    switch(*p){
801034a0:	83 e9 03             	sub    $0x3,%ecx
801034a3:	80 f9 01             	cmp    $0x1,%cl
801034a6:	76 c2                	jbe    8010346a <mpinit+0xfa>
801034a8:	31 f6                	xor    %esi,%esi
801034aa:	eb ac                	jmp    80103458 <mpinit+0xe8>
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801034b0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801034b4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801034b7:	88 0d 80 a7 14 80    	mov    %cl,0x8014a780
      continue;
801034bd:	eb 99                	jmp    80103458 <mpinit+0xe8>
801034bf:	90                   	nop
      if(ncpu < NCPU) {
801034c0:	8b 0d 84 a7 14 80    	mov    0x8014a784,%ecx
801034c6:	83 f9 07             	cmp    $0x7,%ecx
801034c9:	7f 19                	jg     801034e4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034cb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801034d1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801034d5:	83 c1 01             	add    $0x1,%ecx
801034d8:	89 0d 84 a7 14 80    	mov    %ecx,0x8014a784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034de:	88 9f a0 a7 14 80    	mov    %bl,-0x7feb5860(%edi)
      p += sizeof(struct mpproc);
801034e4:	83 c0 14             	add    $0x14,%eax
      continue;
801034e7:	e9 6c ff ff ff       	jmp    80103458 <mpinit+0xe8>
801034ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801034f0:	83 ec 0c             	sub    $0xc,%esp
801034f3:	68 22 7d 10 80       	push   $0x80107d22
801034f8:	e8 83 ce ff ff       	call   80100380 <panic>
801034fd:	8d 76 00             	lea    0x0(%esi),%esi
{
80103500:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103505:	eb 13                	jmp    8010351a <mpinit+0x1aa>
80103507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103510:	89 f3                	mov    %esi,%ebx
80103512:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103518:	74 d6                	je     801034f0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010351a:	83 ec 04             	sub    $0x4,%esp
8010351d:	8d 73 10             	lea    0x10(%ebx),%esi
80103520:	6a 04                	push   $0x4
80103522:	68 18 7d 10 80       	push   $0x80107d18
80103527:	53                   	push   %ebx
80103528:	e8 83 14 00 00       	call   801049b0 <memcmp>
8010352d:	83 c4 10             	add    $0x10,%esp
80103530:	85 c0                	test   %eax,%eax
80103532:	75 dc                	jne    80103510 <mpinit+0x1a0>
80103534:	89 da                	mov    %ebx,%edx
80103536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010353d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103540:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103543:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103546:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103548:	39 d6                	cmp    %edx,%esi
8010354a:	75 f4                	jne    80103540 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010354c:	84 c0                	test   %al,%al
8010354e:	75 c0                	jne    80103510 <mpinit+0x1a0>
80103550:	e9 6b fe ff ff       	jmp    801033c0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103555:	83 ec 0c             	sub    $0xc,%esp
80103558:	68 3c 7d 10 80       	push   $0x80107d3c
8010355d:	e8 1e ce ff ff       	call   80100380 <panic>
80103562:	66 90                	xchg   %ax,%ax
80103564:	66 90                	xchg   %ax,%ax
80103566:	66 90                	xchg   %ax,%ax
80103568:	66 90                	xchg   %ax,%ax
8010356a:	66 90                	xchg   %ax,%ax
8010356c:	66 90                	xchg   %ax,%ax
8010356e:	66 90                	xchg   %ax,%ax

80103570 <picinit>:
80103570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103575:	ba 21 00 00 00       	mov    $0x21,%edx
8010357a:	ee                   	out    %al,(%dx)
8010357b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103580:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103581:	c3                   	ret    
80103582:	66 90                	xchg   %ax,%ax
80103584:	66 90                	xchg   %ax,%ax
80103586:	66 90                	xchg   %ax,%ax
80103588:	66 90                	xchg   %ax,%ax
8010358a:	66 90                	xchg   %ax,%ax
8010358c:	66 90                	xchg   %ax,%ax
8010358e:	66 90                	xchg   %ax,%ax

80103590 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	57                   	push   %edi
80103594:	56                   	push   %esi
80103595:	53                   	push   %ebx
80103596:	83 ec 0c             	sub    $0xc,%esp
80103599:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010359c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010359f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801035a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035ab:	e8 80 d8 ff ff       	call   80100e30 <filealloc>
801035b0:	89 03                	mov    %eax,(%ebx)
801035b2:	85 c0                	test   %eax,%eax
801035b4:	0f 84 a8 00 00 00    	je     80103662 <pipealloc+0xd2>
801035ba:	e8 71 d8 ff ff       	call   80100e30 <filealloc>
801035bf:	89 06                	mov    %eax,(%esi)
801035c1:	85 c0                	test   %eax,%eax
801035c3:	0f 84 87 00 00 00    	je     80103650 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035c9:	e8 e2 f0 ff ff       	call   801026b0 <kalloc>
801035ce:	89 c7                	mov    %eax,%edi
801035d0:	85 c0                	test   %eax,%eax
801035d2:	0f 84 b0 00 00 00    	je     80103688 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801035d8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035df:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801035e2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801035e5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035ec:	00 00 00 
  p->nwrite = 0;
801035ef:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035f6:	00 00 00 
  p->nread = 0;
801035f9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103600:	00 00 00 
  initlock(&p->lock, "pipe");
80103603:	68 5b 7d 10 80       	push   $0x80107d5b
80103608:	50                   	push   %eax
80103609:	e8 c2 10 00 00       	call   801046d0 <initlock>
  (*f0)->type = FD_PIPE;
8010360e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103610:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103613:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103619:	8b 03                	mov    (%ebx),%eax
8010361b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010361f:	8b 03                	mov    (%ebx),%eax
80103621:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103625:	8b 03                	mov    (%ebx),%eax
80103627:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010362a:	8b 06                	mov    (%esi),%eax
8010362c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103632:	8b 06                	mov    (%esi),%eax
80103634:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103638:	8b 06                	mov    (%esi),%eax
8010363a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010363e:	8b 06                	mov    (%esi),%eax
80103640:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103643:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103646:	31 c0                	xor    %eax,%eax
}
80103648:	5b                   	pop    %ebx
80103649:	5e                   	pop    %esi
8010364a:	5f                   	pop    %edi
8010364b:	5d                   	pop    %ebp
8010364c:	c3                   	ret    
8010364d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103650:	8b 03                	mov    (%ebx),%eax
80103652:	85 c0                	test   %eax,%eax
80103654:	74 1e                	je     80103674 <pipealloc+0xe4>
    fileclose(*f0);
80103656:	83 ec 0c             	sub    $0xc,%esp
80103659:	50                   	push   %eax
8010365a:	e8 91 d8 ff ff       	call   80100ef0 <fileclose>
8010365f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103662:	8b 06                	mov    (%esi),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	74 0c                	je     80103674 <pipealloc+0xe4>
    fileclose(*f1);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	50                   	push   %eax
8010366c:	e8 7f d8 ff ff       	call   80100ef0 <fileclose>
80103671:	83 c4 10             	add    $0x10,%esp
}
80103674:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103677:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103688:	8b 03                	mov    (%ebx),%eax
8010368a:	85 c0                	test   %eax,%eax
8010368c:	75 c8                	jne    80103656 <pipealloc+0xc6>
8010368e:	eb d2                	jmp    80103662 <pipealloc+0xd2>

80103690 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	56                   	push   %esi
80103694:	53                   	push   %ebx
80103695:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103698:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010369b:	83 ec 0c             	sub    $0xc,%esp
8010369e:	53                   	push   %ebx
8010369f:	e8 fc 11 00 00       	call   801048a0 <acquire>
  if(writable){
801036a4:	83 c4 10             	add    $0x10,%esp
801036a7:	85 f6                	test   %esi,%esi
801036a9:	74 65                	je     80103710 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801036ab:	83 ec 0c             	sub    $0xc,%esp
801036ae:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801036b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801036bb:	00 00 00 
    wakeup(&p->nread);
801036be:	50                   	push   %eax
801036bf:	e8 3c 0d 00 00       	call   80104400 <wakeup>
801036c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801036c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801036cd:	85 d2                	test   %edx,%edx
801036cf:	75 0a                	jne    801036db <pipeclose+0x4b>
801036d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801036d7:	85 c0                	test   %eax,%eax
801036d9:	74 15                	je     801036f0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801036de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036e1:	5b                   	pop    %ebx
801036e2:	5e                   	pop    %esi
801036e3:	5d                   	pop    %ebp
    release(&p->lock);
801036e4:	e9 57 11 00 00       	jmp    80104840 <release>
801036e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801036f0:	83 ec 0c             	sub    $0xc,%esp
801036f3:	53                   	push   %ebx
801036f4:	e8 47 11 00 00       	call   80104840 <release>
    kfree((char*)p);
801036f9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036fc:	83 c4 10             	add    $0x10,%esp
}
801036ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103702:	5b                   	pop    %ebx
80103703:	5e                   	pop    %esi
80103704:	5d                   	pop    %ebp
    kfree((char*)p);
80103705:	e9 b6 ed ff ff       	jmp    801024c0 <kfree>
8010370a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103710:	83 ec 0c             	sub    $0xc,%esp
80103713:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103719:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103720:	00 00 00 
    wakeup(&p->nwrite);
80103723:	50                   	push   %eax
80103724:	e8 d7 0c 00 00       	call   80104400 <wakeup>
80103729:	83 c4 10             	add    $0x10,%esp
8010372c:	eb 99                	jmp    801036c7 <pipeclose+0x37>
8010372e:	66 90                	xchg   %ax,%ax

80103730 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	57                   	push   %edi
80103734:	56                   	push   %esi
80103735:	53                   	push   %ebx
80103736:	83 ec 28             	sub    $0x28,%esp
80103739:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010373c:	53                   	push   %ebx
8010373d:	e8 5e 11 00 00       	call   801048a0 <acquire>
  for(i = 0; i < n; i++){
80103742:	8b 45 10             	mov    0x10(%ebp),%eax
80103745:	83 c4 10             	add    $0x10,%esp
80103748:	85 c0                	test   %eax,%eax
8010374a:	0f 8e c0 00 00 00    	jle    80103810 <pipewrite+0xe0>
80103750:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103753:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103759:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010375f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103762:	03 45 10             	add    0x10(%ebp),%eax
80103765:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103768:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010376e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103774:	89 ca                	mov    %ecx,%edx
80103776:	05 00 02 00 00       	add    $0x200,%eax
8010377b:	39 c1                	cmp    %eax,%ecx
8010377d:	74 3f                	je     801037be <pipewrite+0x8e>
8010377f:	eb 67                	jmp    801037e8 <pipewrite+0xb8>
80103781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103788:	e8 43 03 00 00       	call   80103ad0 <myproc>
8010378d:	8b 48 24             	mov    0x24(%eax),%ecx
80103790:	85 c9                	test   %ecx,%ecx
80103792:	75 34                	jne    801037c8 <pipewrite+0x98>
      wakeup(&p->nread);
80103794:	83 ec 0c             	sub    $0xc,%esp
80103797:	57                   	push   %edi
80103798:	e8 63 0c 00 00       	call   80104400 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010379d:	58                   	pop    %eax
8010379e:	5a                   	pop    %edx
8010379f:	53                   	push   %ebx
801037a0:	56                   	push   %esi
801037a1:	e8 9a 0b 00 00       	call   80104340 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037a6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037ac:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801037b2:	83 c4 10             	add    $0x10,%esp
801037b5:	05 00 02 00 00       	add    $0x200,%eax
801037ba:	39 c2                	cmp    %eax,%edx
801037bc:	75 2a                	jne    801037e8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801037be:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037c4:	85 c0                	test   %eax,%eax
801037c6:	75 c0                	jne    80103788 <pipewrite+0x58>
        release(&p->lock);
801037c8:	83 ec 0c             	sub    $0xc,%esp
801037cb:	53                   	push   %ebx
801037cc:	e8 6f 10 00 00       	call   80104840 <release>
        return -1;
801037d1:	83 c4 10             	add    $0x10,%esp
801037d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801037d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037dc:	5b                   	pop    %ebx
801037dd:	5e                   	pop    %esi
801037de:	5f                   	pop    %edi
801037df:	5d                   	pop    %ebp
801037e0:	c3                   	ret    
801037e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037e8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801037eb:	8d 4a 01             	lea    0x1(%edx),%ecx
801037ee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037f4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801037fa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801037fd:	83 c6 01             	add    $0x1,%esi
80103800:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103803:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103807:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010380a:	0f 85 58 ff ff ff    	jne    80103768 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103810:	83 ec 0c             	sub    $0xc,%esp
80103813:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103819:	50                   	push   %eax
8010381a:	e8 e1 0b 00 00       	call   80104400 <wakeup>
  release(&p->lock);
8010381f:	89 1c 24             	mov    %ebx,(%esp)
80103822:	e8 19 10 00 00       	call   80104840 <release>
  return n;
80103827:	8b 45 10             	mov    0x10(%ebp),%eax
8010382a:	83 c4 10             	add    $0x10,%esp
8010382d:	eb aa                	jmp    801037d9 <pipewrite+0xa9>
8010382f:	90                   	nop

80103830 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	57                   	push   %edi
80103834:	56                   	push   %esi
80103835:	53                   	push   %ebx
80103836:	83 ec 18             	sub    $0x18,%esp
80103839:	8b 75 08             	mov    0x8(%ebp),%esi
8010383c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010383f:	56                   	push   %esi
80103840:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103846:	e8 55 10 00 00       	call   801048a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010384b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103851:	83 c4 10             	add    $0x10,%esp
80103854:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010385a:	74 2f                	je     8010388b <piperead+0x5b>
8010385c:	eb 37                	jmp    80103895 <piperead+0x65>
8010385e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103860:	e8 6b 02 00 00       	call   80103ad0 <myproc>
80103865:	8b 48 24             	mov    0x24(%eax),%ecx
80103868:	85 c9                	test   %ecx,%ecx
8010386a:	0f 85 80 00 00 00    	jne    801038f0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103870:	83 ec 08             	sub    $0x8,%esp
80103873:	56                   	push   %esi
80103874:	53                   	push   %ebx
80103875:	e8 c6 0a 00 00       	call   80104340 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010387a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103880:	83 c4 10             	add    $0x10,%esp
80103883:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103889:	75 0a                	jne    80103895 <piperead+0x65>
8010388b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103891:	85 c0                	test   %eax,%eax
80103893:	75 cb                	jne    80103860 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103895:	8b 55 10             	mov    0x10(%ebp),%edx
80103898:	31 db                	xor    %ebx,%ebx
8010389a:	85 d2                	test   %edx,%edx
8010389c:	7f 20                	jg     801038be <piperead+0x8e>
8010389e:	eb 2c                	jmp    801038cc <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801038a0:	8d 48 01             	lea    0x1(%eax),%ecx
801038a3:	25 ff 01 00 00       	and    $0x1ff,%eax
801038a8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801038ae:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801038b3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038b6:	83 c3 01             	add    $0x1,%ebx
801038b9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801038bc:	74 0e                	je     801038cc <piperead+0x9c>
    if(p->nread == p->nwrite)
801038be:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038c4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801038ca:	75 d4                	jne    801038a0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801038cc:	83 ec 0c             	sub    $0xc,%esp
801038cf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801038d5:	50                   	push   %eax
801038d6:	e8 25 0b 00 00       	call   80104400 <wakeup>
  release(&p->lock);
801038db:	89 34 24             	mov    %esi,(%esp)
801038de:	e8 5d 0f 00 00       	call   80104840 <release>
  return i;
801038e3:	83 c4 10             	add    $0x10,%esp
}
801038e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038e9:	89 d8                	mov    %ebx,%eax
801038eb:	5b                   	pop    %ebx
801038ec:	5e                   	pop    %esi
801038ed:	5f                   	pop    %edi
801038ee:	5d                   	pop    %ebp
801038ef:	c3                   	ret    
      release(&p->lock);
801038f0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038f3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038f8:	56                   	push   %esi
801038f9:	e8 42 0f 00 00       	call   80104840 <release>
      return -1;
801038fe:	83 c4 10             	add    $0x10,%esp
}
80103901:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103904:	89 d8                	mov    %ebx,%eax
80103906:	5b                   	pop    %ebx
80103907:	5e                   	pop    %esi
80103908:	5f                   	pop    %edi
80103909:	5d                   	pop    %ebp
8010390a:	c3                   	ret    
8010390b:	66 90                	xchg   %ax,%ax
8010390d:	66 90                	xchg   %ax,%ax
8010390f:	90                   	nop

80103910 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103914:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
{
80103919:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010391c:	68 20 ad 14 80       	push   $0x8014ad20
80103921:	e8 7a 0f 00 00       	call   801048a0 <acquire>
80103926:	83 c4 10             	add    $0x10,%esp
80103929:	eb 10                	jmp    8010393b <allocproc+0x2b>
8010392b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010392f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103930:	83 c3 7c             	add    $0x7c,%ebx
80103933:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
80103939:	74 75                	je     801039b0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010393b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010393e:	85 c0                	test   %eax,%eax
80103940:	75 ee                	jne    80103930 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103942:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103947:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010394a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103951:	89 43 10             	mov    %eax,0x10(%ebx)
80103954:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103957:	68 20 ad 14 80       	push   $0x8014ad20
  p->pid = nextpid++;
8010395c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103962:	e8 d9 0e 00 00       	call   80104840 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103967:	e8 44 ed ff ff       	call   801026b0 <kalloc>
8010396c:	83 c4 10             	add    $0x10,%esp
8010396f:	89 43 08             	mov    %eax,0x8(%ebx)
80103972:	85 c0                	test   %eax,%eax
80103974:	74 53                	je     801039c9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103976:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010397c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010397f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103984:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103987:	c7 40 14 57 5c 10 80 	movl   $0x80105c57,0x14(%eax)
  p->context = (struct context*)sp;
8010398e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103991:	6a 14                	push   $0x14
80103993:	6a 00                	push   $0x0
80103995:	50                   	push   %eax
80103996:	e8 c5 0f 00 00       	call   80104960 <memset>
  p->context->eip = (uint)forkret;
8010399b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010399e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801039a1:	c7 40 10 e0 39 10 80 	movl   $0x801039e0,0x10(%eax)
}
801039a8:	89 d8                	mov    %ebx,%eax
801039aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039ad:	c9                   	leave  
801039ae:	c3                   	ret    
801039af:	90                   	nop
  release(&ptable.lock);
801039b0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801039b3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801039b5:	68 20 ad 14 80       	push   $0x8014ad20
801039ba:	e8 81 0e 00 00       	call   80104840 <release>
}
801039bf:	89 d8                	mov    %ebx,%eax
  return 0;
801039c1:	83 c4 10             	add    $0x10,%esp
}
801039c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039c7:	c9                   	leave  
801039c8:	c3                   	ret    
    p->state = UNUSED;
801039c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801039d0:	31 db                	xor    %ebx,%ebx
}
801039d2:	89 d8                	mov    %ebx,%eax
801039d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039d7:	c9                   	leave  
801039d8:	c3                   	ret    
801039d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801039e6:	68 20 ad 14 80       	push   $0x8014ad20
801039eb:	e8 50 0e 00 00       	call   80104840 <release>

  if (first) {
801039f0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801039f5:	83 c4 10             	add    $0x10,%esp
801039f8:	85 c0                	test   %eax,%eax
801039fa:	75 04                	jne    80103a00 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039fc:	c9                   	leave  
801039fd:	c3                   	ret    
801039fe:	66 90                	xchg   %ax,%ax
    first = 0;
80103a00:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a07:	00 00 00 
    iinit(ROOTDEV);
80103a0a:	83 ec 0c             	sub    $0xc,%esp
80103a0d:	6a 01                	push   $0x1
80103a0f:	e8 4c db ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103a14:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a1b:	e8 00 f4 ff ff       	call   80102e20 <initlog>
}
80103a20:	83 c4 10             	add    $0x10,%esp
80103a23:	c9                   	leave  
80103a24:	c3                   	ret    
80103a25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a30 <pinit>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a36:	68 60 7d 10 80       	push   $0x80107d60
80103a3b:	68 20 ad 14 80       	push   $0x8014ad20
80103a40:	e8 8b 0c 00 00       	call   801046d0 <initlock>
}
80103a45:	83 c4 10             	add    $0x10,%esp
80103a48:	c9                   	leave  
80103a49:	c3                   	ret    
80103a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a50 <mycpu>:
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	56                   	push   %esi
80103a54:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a55:	9c                   	pushf  
80103a56:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a57:	f6 c4 02             	test   $0x2,%ah
80103a5a:	75 46                	jne    80103aa2 <mycpu+0x52>
  apicid = lapicid();
80103a5c:	e8 ef ef ff ff       	call   80102a50 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a61:	8b 35 84 a7 14 80    	mov    0x8014a784,%esi
80103a67:	85 f6                	test   %esi,%esi
80103a69:	7e 2a                	jle    80103a95 <mycpu+0x45>
80103a6b:	31 d2                	xor    %edx,%edx
80103a6d:	eb 08                	jmp    80103a77 <mycpu+0x27>
80103a6f:	90                   	nop
80103a70:	83 c2 01             	add    $0x1,%edx
80103a73:	39 f2                	cmp    %esi,%edx
80103a75:	74 1e                	je     80103a95 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103a77:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a7d:	0f b6 99 a0 a7 14 80 	movzbl -0x7feb5860(%ecx),%ebx
80103a84:	39 c3                	cmp    %eax,%ebx
80103a86:	75 e8                	jne    80103a70 <mycpu+0x20>
}
80103a88:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a8b:	8d 81 a0 a7 14 80    	lea    -0x7feb5860(%ecx),%eax
}
80103a91:	5b                   	pop    %ebx
80103a92:	5e                   	pop    %esi
80103a93:	5d                   	pop    %ebp
80103a94:	c3                   	ret    
  panic("unknown apicid\n");
80103a95:	83 ec 0c             	sub    $0xc,%esp
80103a98:	68 67 7d 10 80       	push   $0x80107d67
80103a9d:	e8 de c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103aa2:	83 ec 0c             	sub    $0xc,%esp
80103aa5:	68 7c 7e 10 80       	push   $0x80107e7c
80103aaa:	e8 d1 c8 ff ff       	call   80100380 <panic>
80103aaf:	90                   	nop

80103ab0 <cpuid>:
cpuid() {
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103ab6:	e8 95 ff ff ff       	call   80103a50 <mycpu>
}
80103abb:	c9                   	leave  
  return mycpu()-cpus;
80103abc:	2d a0 a7 14 80       	sub    $0x8014a7a0,%eax
80103ac1:	c1 f8 04             	sar    $0x4,%eax
80103ac4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103aca:	c3                   	ret    
80103acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103acf:	90                   	nop

80103ad0 <myproc>:
myproc(void) {
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	53                   	push   %ebx
80103ad4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ad7:	e8 74 0c 00 00       	call   80104750 <pushcli>
  c = mycpu();
80103adc:	e8 6f ff ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80103ae1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ae7:	e8 b4 0c 00 00       	call   801047a0 <popcli>
}
80103aec:	89 d8                	mov    %ebx,%eax
80103aee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103af1:	c9                   	leave  
80103af2:	c3                   	ret    
80103af3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b00 <userinit>:
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	53                   	push   %ebx
80103b04:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b07:	e8 04 fe ff ff       	call   80103910 <allocproc>
80103b0c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b0e:	a3 54 cc 14 80       	mov    %eax,0x8014cc54
  if((p->pgdir = setupkvm()) == 0)
80103b13:	e8 b8 38 00 00       	call   801073d0 <setupkvm>
80103b18:	89 43 04             	mov    %eax,0x4(%ebx)
80103b1b:	85 c0                	test   %eax,%eax
80103b1d:	0f 84 bd 00 00 00    	je     80103be0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b23:	83 ec 04             	sub    $0x4,%esp
80103b26:	68 2c 00 00 00       	push   $0x2c
80103b2b:	68 60 b4 10 80       	push   $0x8010b460
80103b30:	50                   	push   %eax
80103b31:	e8 4a 35 00 00       	call   80107080 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b36:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b39:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b3f:	6a 4c                	push   $0x4c
80103b41:	6a 00                	push   $0x0
80103b43:	ff 73 18             	push   0x18(%ebx)
80103b46:	e8 15 0e 00 00       	call   80104960 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b4b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b4e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b53:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b56:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b5b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b5f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b62:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b66:	8b 43 18             	mov    0x18(%ebx),%eax
80103b69:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b6d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b71:	8b 43 18             	mov    0x18(%ebx),%eax
80103b74:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b78:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b7c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b7f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b86:	8b 43 18             	mov    0x18(%ebx),%eax
80103b89:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b90:	8b 43 18             	mov    0x18(%ebx),%eax
80103b93:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b9a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b9d:	6a 10                	push   $0x10
80103b9f:	68 90 7d 10 80       	push   $0x80107d90
80103ba4:	50                   	push   %eax
80103ba5:	e8 76 0f 00 00       	call   80104b20 <safestrcpy>
  p->cwd = namei("/");
80103baa:	c7 04 24 99 7d 10 80 	movl   $0x80107d99,(%esp)
80103bb1:	e8 ea e4 ff ff       	call   801020a0 <namei>
80103bb6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103bb9:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103bc0:	e8 db 0c 00 00       	call   801048a0 <acquire>
  p->state = RUNNABLE;
80103bc5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bcc:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103bd3:	e8 68 0c 00 00       	call   80104840 <release>
}
80103bd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bdb:	83 c4 10             	add    $0x10,%esp
80103bde:	c9                   	leave  
80103bdf:	c3                   	ret    
    panic("userinit: out of memory?");
80103be0:	83 ec 0c             	sub    $0xc,%esp
80103be3:	68 77 7d 10 80       	push   $0x80107d77
80103be8:	e8 93 c7 ff ff       	call   80100380 <panic>
80103bed:	8d 76 00             	lea    0x0(%esi),%esi

80103bf0 <growproc>:
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	56                   	push   %esi
80103bf4:	53                   	push   %ebx
80103bf5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103bf8:	e8 53 0b 00 00       	call   80104750 <pushcli>
  c = mycpu();
80103bfd:	e8 4e fe ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80103c02:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c08:	e8 93 0b 00 00       	call   801047a0 <popcli>
  sz = curproc->sz;
80103c0d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c0f:	85 f6                	test   %esi,%esi
80103c11:	7f 1d                	jg     80103c30 <growproc+0x40>
  } else if(n < 0){
80103c13:	75 3b                	jne    80103c50 <growproc+0x60>
  switchuvm(curproc);
80103c15:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c18:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c1a:	53                   	push   %ebx
80103c1b:	e8 50 33 00 00       	call   80106f70 <switchuvm>
  return 0;
80103c20:	83 c4 10             	add    $0x10,%esp
80103c23:	31 c0                	xor    %eax,%eax
}
80103c25:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c28:	5b                   	pop    %ebx
80103c29:	5e                   	pop    %esi
80103c2a:	5d                   	pop    %ebp
80103c2b:	c3                   	ret    
80103c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c30:	83 ec 04             	sub    $0x4,%esp
80103c33:	01 c6                	add    %eax,%esi
80103c35:	56                   	push   %esi
80103c36:	50                   	push   %eax
80103c37:	ff 73 04             	push   0x4(%ebx)
80103c3a:	e8 b1 35 00 00       	call   801071f0 <allocuvm>
80103c3f:	83 c4 10             	add    $0x10,%esp
80103c42:	85 c0                	test   %eax,%eax
80103c44:	75 cf                	jne    80103c15 <growproc+0x25>
      return -1;
80103c46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c4b:	eb d8                	jmp    80103c25 <growproc+0x35>
80103c4d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c50:	83 ec 04             	sub    $0x4,%esp
80103c53:	01 c6                	add    %eax,%esi
80103c55:	56                   	push   %esi
80103c56:	50                   	push   %eax
80103c57:	ff 73 04             	push   0x4(%ebx)
80103c5a:	e8 c1 36 00 00       	call   80107320 <deallocuvm>
80103c5f:	83 c4 10             	add    $0x10,%esp
80103c62:	85 c0                	test   %eax,%eax
80103c64:	75 af                	jne    80103c15 <growproc+0x25>
80103c66:	eb de                	jmp    80103c46 <growproc+0x56>
80103c68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c6f:	90                   	nop

80103c70 <fork>:
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	57                   	push   %edi
80103c74:	56                   	push   %esi
80103c75:	53                   	push   %ebx
80103c76:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c79:	e8 d2 0a 00 00       	call   80104750 <pushcli>
  c = mycpu();
80103c7e:	e8 cd fd ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80103c83:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c89:	e8 12 0b 00 00       	call   801047a0 <popcli>
  if((np = allocproc()) == 0){
80103c8e:	e8 7d fc ff ff       	call   80103910 <allocproc>
80103c93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c96:	85 c0                	test   %eax,%eax
80103c98:	0f 84 b7 00 00 00    	je     80103d55 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c9e:	83 ec 08             	sub    $0x8,%esp
80103ca1:	ff 33                	push   (%ebx)
80103ca3:	89 c7                	mov    %eax,%edi
80103ca5:	ff 73 04             	push   0x4(%ebx)
80103ca8:	e8 13 38 00 00       	call   801074c0 <copyuvm>
80103cad:	83 c4 10             	add    $0x10,%esp
80103cb0:	89 47 04             	mov    %eax,0x4(%edi)
80103cb3:	85 c0                	test   %eax,%eax
80103cb5:	0f 84 a1 00 00 00    	je     80103d5c <fork+0xec>
  np->sz = curproc->sz;
80103cbb:	8b 03                	mov    (%ebx),%eax
80103cbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103cc0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103cc2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103cc5:	89 c8                	mov    %ecx,%eax
80103cc7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103cca:	b9 13 00 00 00       	mov    $0x13,%ecx
80103ccf:	8b 73 18             	mov    0x18(%ebx),%esi
80103cd2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103cd4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103cd6:	8b 40 18             	mov    0x18(%eax),%eax
80103cd9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103ce0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ce4:	85 c0                	test   %eax,%eax
80103ce6:	74 13                	je     80103cfb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ce8:	83 ec 0c             	sub    $0xc,%esp
80103ceb:	50                   	push   %eax
80103cec:	e8 af d1 ff ff       	call   80100ea0 <filedup>
80103cf1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103cf4:	83 c4 10             	add    $0x10,%esp
80103cf7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103cfb:	83 c6 01             	add    $0x1,%esi
80103cfe:	83 fe 10             	cmp    $0x10,%esi
80103d01:	75 dd                	jne    80103ce0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103d03:	83 ec 0c             	sub    $0xc,%esp
80103d06:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d09:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d0c:	e8 3f da ff ff       	call   80101750 <idup>
80103d11:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d14:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d17:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d1a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d1d:	6a 10                	push   $0x10
80103d1f:	53                   	push   %ebx
80103d20:	50                   	push   %eax
80103d21:	e8 fa 0d 00 00       	call   80104b20 <safestrcpy>
  pid = np->pid;
80103d26:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d29:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103d30:	e8 6b 0b 00 00       	call   801048a0 <acquire>
  np->state = RUNNABLE;
80103d35:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d3c:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103d43:	e8 f8 0a 00 00       	call   80104840 <release>
  return pid;
80103d48:	83 c4 10             	add    $0x10,%esp
}
80103d4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d4e:	89 d8                	mov    %ebx,%eax
80103d50:	5b                   	pop    %ebx
80103d51:	5e                   	pop    %esi
80103d52:	5f                   	pop    %edi
80103d53:	5d                   	pop    %ebp
80103d54:	c3                   	ret    
    return -1;
80103d55:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d5a:	eb ef                	jmp    80103d4b <fork+0xdb>
    kfree(np->kstack);
80103d5c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d5f:	83 ec 0c             	sub    $0xc,%esp
80103d62:	ff 73 08             	push   0x8(%ebx)
80103d65:	e8 56 e7 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103d6a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d71:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d74:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d7b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d80:	eb c9                	jmp    80103d4b <fork+0xdb>
80103d82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d90 <forkcow>:
forkcow(void) {
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	57                   	push   %edi
80103d94:	56                   	push   %esi
80103d95:	53                   	push   %ebx
80103d96:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d99:	e8 b2 09 00 00       	call   80104750 <pushcli>
  c = mycpu();
80103d9e:	e8 ad fc ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80103da3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103da9:	e8 f2 09 00 00       	call   801047a0 <popcli>
  cprintf("forkcow: Starting process forking\n");
80103dae:	83 ec 0c             	sub    $0xc,%esp
80103db1:	68 a4 7e 10 80       	push   $0x80107ea4
80103db6:	e8 e5 c8 ff ff       	call   801006a0 <cprintf>
  if((np = allocproc()) == 0) {
80103dbb:	e8 50 fb ff ff       	call   80103910 <allocproc>
80103dc0:	83 c4 10             	add    $0x10,%esp
80103dc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103dc6:	85 c0                	test   %eax,%eax
80103dc8:	0f 84 0c 01 00 00    	je     80103eda <forkcow+0x14a>
  cprintf("forkcow: allocproc succeeded, now calling copyuvmcow\n");
80103dce:	83 ec 0c             	sub    $0xc,%esp
80103dd1:	68 c8 7e 10 80       	push   $0x80107ec8
80103dd6:	e8 c5 c8 ff ff       	call   801006a0 <cprintf>
  if((np->pgdir = copyuvmcow(curproc->pgdir, curproc->sz)) == 0) {
80103ddb:	5e                   	pop    %esi
80103ddc:	5f                   	pop    %edi
80103ddd:	ff 33                	push   (%ebx)
80103ddf:	ff 73 04             	push   0x4(%ebx)
80103de2:	e8 09 38 00 00       	call   801075f0 <copyuvmcow>
80103de7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103dea:	83 c4 10             	add    $0x10,%esp
80103ded:	89 41 04             	mov    %eax,0x4(%ecx)
80103df0:	85 c0                	test   %eax,%eax
80103df2:	0f 84 f9 00 00 00    	je     80103ef1 <forkcow+0x161>
  cprintf("forkcow: copyuvmcow succeeded\n");
80103df8:	83 ec 0c             	sub    $0xc,%esp
80103dfb:	68 00 7f 10 80       	push   $0x80107f00
80103e00:	e8 9b c8 ff ff       	call   801006a0 <cprintf>
  np->sz = curproc->sz;
80103e05:	8b 03                	mov    (%ebx),%eax
80103e07:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  np->tf->eax = 0;
80103e0a:	83 c4 10             	add    $0x10,%esp
  np->sz = curproc->sz;
80103e0d:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103e0f:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103e12:	89 c8                	mov    %ecx,%eax
80103e14:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103e17:	b9 13 00 00 00       	mov    $0x13,%ecx
80103e1c:	8b 73 18             	mov    0x18(%ebx),%esi
80103e1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++) {
80103e21:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e23:	8b 40 18             	mov    0x18(%eax),%eax
80103e26:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++) {
80103e2d:	eb 09                	jmp    80103e38 <forkcow+0xa8>
80103e2f:	90                   	nop
80103e30:	83 c6 01             	add    $0x1,%esi
80103e33:	83 fe 10             	cmp    $0x10,%esi
80103e36:	74 38                	je     80103e70 <forkcow+0xe0>
    if(curproc->ofile[i]) {
80103e38:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e3c:	85 c0                	test   %eax,%eax
80103e3e:	74 f0                	je     80103e30 <forkcow+0xa0>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e40:	83 ec 0c             	sub    $0xc,%esp
80103e43:	50                   	push   %eax
80103e44:	e8 57 d0 ff ff       	call   80100ea0 <filedup>
80103e49:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      if (np->ofile[i] == 0) {
80103e4c:	83 c4 10             	add    $0x10,%esp
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e4f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
      if (np->ofile[i] == 0) {
80103e53:	85 c0                	test   %eax,%eax
80103e55:	75 d9                	jne    80103e30 <forkcow+0xa0>
        cprintf("forkcow: filedup failed for fd %d\n", i);
80103e57:	83 ec 08             	sub    $0x8,%esp
80103e5a:	56                   	push   %esi
  for(i = 0; i < NOFILE; i++) {
80103e5b:	83 c6 01             	add    $0x1,%esi
        cprintf("forkcow: filedup failed for fd %d\n", i);
80103e5e:	68 20 7f 10 80       	push   $0x80107f20
80103e63:	e8 38 c8 ff ff       	call   801006a0 <cprintf>
80103e68:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++) {
80103e6b:	83 fe 10             	cmp    $0x10,%esi
80103e6e:	75 c8                	jne    80103e38 <forkcow+0xa8>
  cprintf("forkcow: file descriptors duplicated\n");
80103e70:	83 ec 0c             	sub    $0xc,%esp
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e73:	83 c3 6c             	add    $0x6c,%ebx
  cprintf("forkcow: file descriptors duplicated\n");
80103e76:	68 44 7f 10 80       	push   $0x80107f44
80103e7b:	e8 20 c8 ff ff       	call   801006a0 <cprintf>
  np->cwd = idup(curproc->cwd);
80103e80:	58                   	pop    %eax
80103e81:	ff 73 fc             	push   -0x4(%ebx)
80103e84:	e8 c7 d8 ff ff       	call   80101750 <idup>
80103e89:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e8c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e8f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e92:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e95:	6a 10                	push   $0x10
80103e97:	53                   	push   %ebx
80103e98:	50                   	push   %eax
80103e99:	e8 82 0c 00 00       	call   80104b20 <safestrcpy>
  pid = np->pid;
80103e9e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103ea1:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103ea8:	e8 f3 09 00 00       	call   801048a0 <acquire>
  np->state = RUNNABLE;
80103ead:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103eb4:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103ebb:	e8 80 09 00 00       	call   80104840 <release>
  cprintf("forkcow: new process created with pid %d\n", pid);
80103ec0:	5a                   	pop    %edx
80103ec1:	59                   	pop    %ecx
80103ec2:	53                   	push   %ebx
80103ec3:	68 6c 7f 10 80       	push   $0x80107f6c
80103ec8:	e8 d3 c7 ff ff       	call   801006a0 <cprintf>
  return pid;
80103ecd:	83 c4 10             	add    $0x10,%esp
}
80103ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ed3:	89 d8                	mov    %ebx,%eax
80103ed5:	5b                   	pop    %ebx
80103ed6:	5e                   	pop    %esi
80103ed7:	5f                   	pop    %edi
80103ed8:	5d                   	pop    %ebp
80103ed9:	c3                   	ret    
    cprintf("forkcow: allocproc failed\n");
80103eda:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103edd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    cprintf("forkcow: allocproc failed\n");
80103ee2:	68 9b 7d 10 80       	push   $0x80107d9b
80103ee7:	e8 b4 c7 ff ff       	call   801006a0 <cprintf>
    return -1;
80103eec:	83 c4 10             	add    $0x10,%esp
80103eef:	eb df                	jmp    80103ed0 <forkcow+0x140>
    cprintf("forkcow: copyuvmcow failed\n");
80103ef1:	83 ec 0c             	sub    $0xc,%esp
80103ef4:	68 b6 7d 10 80       	push   $0x80107db6
80103ef9:	e8 a2 c7 ff ff       	call   801006a0 <cprintf>
    kfree(np->kstack);
80103efe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103f01:	5b                   	pop    %ebx
    return -1;
80103f02:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103f07:	ff 77 08             	push   0x8(%edi)
80103f0a:	e8 b1 e5 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103f0f:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    return -1;
80103f16:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103f19:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103f20:	eb ae                	jmp    80103ed0 <forkcow+0x140>
80103f22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f30 <scheduler>:
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	57                   	push   %edi
80103f34:	56                   	push   %esi
80103f35:	53                   	push   %ebx
80103f36:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103f39:	e8 12 fb ff ff       	call   80103a50 <mycpu>
  c->proc = 0;
80103f3e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f45:	00 00 00 
  struct cpu *c = mycpu();
80103f48:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103f4a:	8d 78 04             	lea    0x4(%eax),%edi
80103f4d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103f50:	fb                   	sti    
    acquire(&ptable.lock);
80103f51:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f54:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
    acquire(&ptable.lock);
80103f59:	68 20 ad 14 80       	push   $0x8014ad20
80103f5e:	e8 3d 09 00 00       	call   801048a0 <acquire>
80103f63:	83 c4 10             	add    $0x10,%esp
80103f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f6d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103f70:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f74:	75 33                	jne    80103fa9 <scheduler+0x79>
      switchuvm(p);
80103f76:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f79:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f7f:	53                   	push   %ebx
80103f80:	e8 eb 2f 00 00       	call   80106f70 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103f85:	58                   	pop    %eax
80103f86:	5a                   	pop    %edx
80103f87:	ff 73 1c             	push   0x1c(%ebx)
80103f8a:	57                   	push   %edi
      p->state = RUNNING;
80103f8b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103f92:	e8 e4 0b 00 00       	call   80104b7b <swtch>
      switchkvm();
80103f97:	e8 c4 2f 00 00       	call   80106f60 <switchkvm>
      c->proc = 0;
80103f9c:	83 c4 10             	add    $0x10,%esp
80103f9f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103fa6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa9:	83 c3 7c             	add    $0x7c,%ebx
80103fac:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
80103fb2:	75 bc                	jne    80103f70 <scheduler+0x40>
    release(&ptable.lock);
80103fb4:	83 ec 0c             	sub    $0xc,%esp
80103fb7:	68 20 ad 14 80       	push   $0x8014ad20
80103fbc:	e8 7f 08 00 00       	call   80104840 <release>
    sti();
80103fc1:	83 c4 10             	add    $0x10,%esp
80103fc4:	eb 8a                	jmp    80103f50 <scheduler+0x20>
80103fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fcd:	8d 76 00             	lea    0x0(%esi),%esi

80103fd0 <sched>:
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	56                   	push   %esi
80103fd4:	53                   	push   %ebx
  pushcli();
80103fd5:	e8 76 07 00 00       	call   80104750 <pushcli>
  c = mycpu();
80103fda:	e8 71 fa ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80103fdf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fe5:	e8 b6 07 00 00       	call   801047a0 <popcli>
  if(!holding(&ptable.lock))
80103fea:	83 ec 0c             	sub    $0xc,%esp
80103fed:	68 20 ad 14 80       	push   $0x8014ad20
80103ff2:	e8 09 08 00 00       	call   80104800 <holding>
80103ff7:	83 c4 10             	add    $0x10,%esp
80103ffa:	85 c0                	test   %eax,%eax
80103ffc:	74 4f                	je     8010404d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103ffe:	e8 4d fa ff ff       	call   80103a50 <mycpu>
80104003:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010400a:	75 68                	jne    80104074 <sched+0xa4>
  if(p->state == RUNNING)
8010400c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104010:	74 55                	je     80104067 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104012:	9c                   	pushf  
80104013:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104014:	f6 c4 02             	test   $0x2,%ah
80104017:	75 41                	jne    8010405a <sched+0x8a>
  intena = mycpu()->intena;
80104019:	e8 32 fa ff ff       	call   80103a50 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010401e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104021:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104027:	e8 24 fa ff ff       	call   80103a50 <mycpu>
8010402c:	83 ec 08             	sub    $0x8,%esp
8010402f:	ff 70 04             	push   0x4(%eax)
80104032:	53                   	push   %ebx
80104033:	e8 43 0b 00 00       	call   80104b7b <swtch>
  mycpu()->intena = intena;
80104038:	e8 13 fa ff ff       	call   80103a50 <mycpu>
}
8010403d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104040:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104046:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104049:	5b                   	pop    %ebx
8010404a:	5e                   	pop    %esi
8010404b:	5d                   	pop    %ebp
8010404c:	c3                   	ret    
    panic("sched ptable.lock");
8010404d:	83 ec 0c             	sub    $0xc,%esp
80104050:	68 d2 7d 10 80       	push   $0x80107dd2
80104055:	e8 26 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010405a:	83 ec 0c             	sub    $0xc,%esp
8010405d:	68 fe 7d 10 80       	push   $0x80107dfe
80104062:	e8 19 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80104067:	83 ec 0c             	sub    $0xc,%esp
8010406a:	68 f0 7d 10 80       	push   $0x80107df0
8010406f:	e8 0c c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104074:	83 ec 0c             	sub    $0xc,%esp
80104077:	68 e4 7d 10 80       	push   $0x80107de4
8010407c:	e8 ff c2 ff ff       	call   80100380 <panic>
80104081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104088:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010408f:	90                   	nop

80104090 <exit>:
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104099:	e8 32 fa ff ff       	call   80103ad0 <myproc>
  if(curproc == initproc)
8010409e:	39 05 54 cc 14 80    	cmp    %eax,0x8014cc54
801040a4:	0f 84 fd 00 00 00    	je     801041a7 <exit+0x117>
801040aa:	89 c3                	mov    %eax,%ebx
801040ac:	8d 70 28             	lea    0x28(%eax),%esi
801040af:	8d 78 68             	lea    0x68(%eax),%edi
801040b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801040b8:	8b 06                	mov    (%esi),%eax
801040ba:	85 c0                	test   %eax,%eax
801040bc:	74 12                	je     801040d0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801040be:	83 ec 0c             	sub    $0xc,%esp
801040c1:	50                   	push   %eax
801040c2:	e8 29 ce ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
801040c7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801040cd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801040d0:	83 c6 04             	add    $0x4,%esi
801040d3:	39 f7                	cmp    %esi,%edi
801040d5:	75 e1                	jne    801040b8 <exit+0x28>
  begin_op();
801040d7:	e8 e4 ed ff ff       	call   80102ec0 <begin_op>
  iput(curproc->cwd);
801040dc:	83 ec 0c             	sub    $0xc,%esp
801040df:	ff 73 68             	push   0x68(%ebx)
801040e2:	e8 c9 d7 ff ff       	call   801018b0 <iput>
  end_op();
801040e7:	e8 44 ee ff ff       	call   80102f30 <end_op>
  curproc->cwd = 0;
801040ec:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801040f3:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
801040fa:	e8 a1 07 00 00       	call   801048a0 <acquire>
  wakeup1(curproc->parent);
801040ff:	8b 53 14             	mov    0x14(%ebx),%edx
80104102:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104105:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
8010410a:	eb 0e                	jmp    8010411a <exit+0x8a>
8010410c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104110:	83 c0 7c             	add    $0x7c,%eax
80104113:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104118:	74 1c                	je     80104136 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010411a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010411e:	75 f0                	jne    80104110 <exit+0x80>
80104120:	3b 50 20             	cmp    0x20(%eax),%edx
80104123:	75 eb                	jne    80104110 <exit+0x80>
      p->state = RUNNABLE;
80104125:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010412c:	83 c0 7c             	add    $0x7c,%eax
8010412f:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104134:	75 e4                	jne    8010411a <exit+0x8a>
      p->parent = initproc;
80104136:	8b 0d 54 cc 14 80    	mov    0x8014cc54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010413c:	ba 54 ad 14 80       	mov    $0x8014ad54,%edx
80104141:	eb 10                	jmp    80104153 <exit+0xc3>
80104143:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104147:	90                   	nop
80104148:	83 c2 7c             	add    $0x7c,%edx
8010414b:	81 fa 54 cc 14 80    	cmp    $0x8014cc54,%edx
80104151:	74 3b                	je     8010418e <exit+0xfe>
    if(p->parent == curproc){
80104153:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104156:	75 f0                	jne    80104148 <exit+0xb8>
      if(p->state == ZOMBIE)
80104158:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010415c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010415f:	75 e7                	jne    80104148 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104161:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
80104166:	eb 12                	jmp    8010417a <exit+0xea>
80104168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416f:	90                   	nop
80104170:	83 c0 7c             	add    $0x7c,%eax
80104173:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104178:	74 ce                	je     80104148 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010417a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010417e:	75 f0                	jne    80104170 <exit+0xe0>
80104180:	3b 48 20             	cmp    0x20(%eax),%ecx
80104183:	75 eb                	jne    80104170 <exit+0xe0>
      p->state = RUNNABLE;
80104185:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010418c:	eb e2                	jmp    80104170 <exit+0xe0>
  curproc->state = ZOMBIE;
8010418e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104195:	e8 36 fe ff ff       	call   80103fd0 <sched>
  panic("zombie exit");
8010419a:	83 ec 0c             	sub    $0xc,%esp
8010419d:	68 1f 7e 10 80       	push   $0x80107e1f
801041a2:	e8 d9 c1 ff ff       	call   80100380 <panic>
    panic("init exiting");
801041a7:	83 ec 0c             	sub    $0xc,%esp
801041aa:	68 12 7e 10 80       	push   $0x80107e12
801041af:	e8 cc c1 ff ff       	call   80100380 <panic>
801041b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041bf:	90                   	nop

801041c0 <wait>:
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	56                   	push   %esi
801041c4:	53                   	push   %ebx
  pushcli();
801041c5:	e8 86 05 00 00       	call   80104750 <pushcli>
  c = mycpu();
801041ca:	e8 81 f8 ff ff       	call   80103a50 <mycpu>
  p = c->proc;
801041cf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041d5:	e8 c6 05 00 00       	call   801047a0 <popcli>
  acquire(&ptable.lock);
801041da:	83 ec 0c             	sub    $0xc,%esp
801041dd:	68 20 ad 14 80       	push   $0x8014ad20
801041e2:	e8 b9 06 00 00       	call   801048a0 <acquire>
801041e7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801041ea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041ec:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
801041f1:	eb 10                	jmp    80104203 <wait+0x43>
801041f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041f7:	90                   	nop
801041f8:	83 c3 7c             	add    $0x7c,%ebx
801041fb:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
80104201:	74 1b                	je     8010421e <wait+0x5e>
      if(p->parent != curproc)
80104203:	39 73 14             	cmp    %esi,0x14(%ebx)
80104206:	75 f0                	jne    801041f8 <wait+0x38>
      if(p->state == ZOMBIE){
80104208:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010420c:	74 62                	je     80104270 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010420e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104211:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104216:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
8010421c:	75 e5                	jne    80104203 <wait+0x43>
    if(!havekids || curproc->killed){
8010421e:	85 c0                	test   %eax,%eax
80104220:	0f 84 a0 00 00 00    	je     801042c6 <wait+0x106>
80104226:	8b 46 24             	mov    0x24(%esi),%eax
80104229:	85 c0                	test   %eax,%eax
8010422b:	0f 85 95 00 00 00    	jne    801042c6 <wait+0x106>
  pushcli();
80104231:	e8 1a 05 00 00       	call   80104750 <pushcli>
  c = mycpu();
80104236:	e8 15 f8 ff ff       	call   80103a50 <mycpu>
  p = c->proc;
8010423b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104241:	e8 5a 05 00 00       	call   801047a0 <popcli>
  if(p == 0)
80104246:	85 db                	test   %ebx,%ebx
80104248:	0f 84 8f 00 00 00    	je     801042dd <wait+0x11d>
  p->chan = chan;
8010424e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104251:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104258:	e8 73 fd ff ff       	call   80103fd0 <sched>
  p->chan = 0;
8010425d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104264:	eb 84                	jmp    801041ea <wait+0x2a>
80104266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010426d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104270:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104273:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104276:	ff 73 08             	push   0x8(%ebx)
80104279:	e8 42 e2 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
8010427e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104285:	5a                   	pop    %edx
80104286:	ff 73 04             	push   0x4(%ebx)
80104289:	e8 c2 30 00 00       	call   80107350 <freevm>
        p->pid = 0;
8010428e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104295:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010429c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801042a0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801042a7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801042ae:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
801042b5:	e8 86 05 00 00       	call   80104840 <release>
        return pid;
801042ba:	83 c4 10             	add    $0x10,%esp
}
801042bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042c0:	89 f0                	mov    %esi,%eax
801042c2:	5b                   	pop    %ebx
801042c3:	5e                   	pop    %esi
801042c4:	5d                   	pop    %ebp
801042c5:	c3                   	ret    
      release(&ptable.lock);
801042c6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801042c9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801042ce:	68 20 ad 14 80       	push   $0x8014ad20
801042d3:	e8 68 05 00 00       	call   80104840 <release>
      return -1;
801042d8:	83 c4 10             	add    $0x10,%esp
801042db:	eb e0                	jmp    801042bd <wait+0xfd>
    panic("sleep");
801042dd:	83 ec 0c             	sub    $0xc,%esp
801042e0:	68 2b 7e 10 80       	push   $0x80107e2b
801042e5:	e8 96 c0 ff ff       	call   80100380 <panic>
801042ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042f0 <yield>:
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	53                   	push   %ebx
801042f4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801042f7:	68 20 ad 14 80       	push   $0x8014ad20
801042fc:	e8 9f 05 00 00       	call   801048a0 <acquire>
  pushcli();
80104301:	e8 4a 04 00 00       	call   80104750 <pushcli>
  c = mycpu();
80104306:	e8 45 f7 ff ff       	call   80103a50 <mycpu>
  p = c->proc;
8010430b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104311:	e8 8a 04 00 00       	call   801047a0 <popcli>
  myproc()->state = RUNNABLE;
80104316:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010431d:	e8 ae fc ff ff       	call   80103fd0 <sched>
  release(&ptable.lock);
80104322:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80104329:	e8 12 05 00 00       	call   80104840 <release>
}
8010432e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104331:	83 c4 10             	add    $0x10,%esp
80104334:	c9                   	leave  
80104335:	c3                   	ret    
80104336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010433d:	8d 76 00             	lea    0x0(%esi),%esi

80104340 <sleep>:
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	56                   	push   %esi
80104345:	53                   	push   %ebx
80104346:	83 ec 0c             	sub    $0xc,%esp
80104349:	8b 7d 08             	mov    0x8(%ebp),%edi
8010434c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010434f:	e8 fc 03 00 00       	call   80104750 <pushcli>
  c = mycpu();
80104354:	e8 f7 f6 ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80104359:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010435f:	e8 3c 04 00 00       	call   801047a0 <popcli>
  if(p == 0)
80104364:	85 db                	test   %ebx,%ebx
80104366:	0f 84 87 00 00 00    	je     801043f3 <sleep+0xb3>
  if(lk == 0)
8010436c:	85 f6                	test   %esi,%esi
8010436e:	74 76                	je     801043e6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104370:	81 fe 20 ad 14 80    	cmp    $0x8014ad20,%esi
80104376:	74 50                	je     801043c8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104378:	83 ec 0c             	sub    $0xc,%esp
8010437b:	68 20 ad 14 80       	push   $0x8014ad20
80104380:	e8 1b 05 00 00       	call   801048a0 <acquire>
    release(lk);
80104385:	89 34 24             	mov    %esi,(%esp)
80104388:	e8 b3 04 00 00       	call   80104840 <release>
  p->chan = chan;
8010438d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104390:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104397:	e8 34 fc ff ff       	call   80103fd0 <sched>
  p->chan = 0;
8010439c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801043a3:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
801043aa:	e8 91 04 00 00       	call   80104840 <release>
    acquire(lk);
801043af:	89 75 08             	mov    %esi,0x8(%ebp)
801043b2:	83 c4 10             	add    $0x10,%esp
}
801043b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043b8:	5b                   	pop    %ebx
801043b9:	5e                   	pop    %esi
801043ba:	5f                   	pop    %edi
801043bb:	5d                   	pop    %ebp
    acquire(lk);
801043bc:	e9 df 04 00 00       	jmp    801048a0 <acquire>
801043c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801043c8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043cb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043d2:	e8 f9 fb ff ff       	call   80103fd0 <sched>
  p->chan = 0;
801043d7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801043de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043e1:	5b                   	pop    %ebx
801043e2:	5e                   	pop    %esi
801043e3:	5f                   	pop    %edi
801043e4:	5d                   	pop    %ebp
801043e5:	c3                   	ret    
    panic("sleep without lk");
801043e6:	83 ec 0c             	sub    $0xc,%esp
801043e9:	68 31 7e 10 80       	push   $0x80107e31
801043ee:	e8 8d bf ff ff       	call   80100380 <panic>
    panic("sleep");
801043f3:	83 ec 0c             	sub    $0xc,%esp
801043f6:	68 2b 7e 10 80       	push   $0x80107e2b
801043fb:	e8 80 bf ff ff       	call   80100380 <panic>

80104400 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	83 ec 10             	sub    $0x10,%esp
80104407:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010440a:	68 20 ad 14 80       	push   $0x8014ad20
8010440f:	e8 8c 04 00 00       	call   801048a0 <acquire>
80104414:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104417:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
8010441c:	eb 0c                	jmp    8010442a <wakeup+0x2a>
8010441e:	66 90                	xchg   %ax,%ax
80104420:	83 c0 7c             	add    $0x7c,%eax
80104423:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104428:	74 1c                	je     80104446 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010442a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010442e:	75 f0                	jne    80104420 <wakeup+0x20>
80104430:	3b 58 20             	cmp    0x20(%eax),%ebx
80104433:	75 eb                	jne    80104420 <wakeup+0x20>
      p->state = RUNNABLE;
80104435:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010443c:	83 c0 7c             	add    $0x7c,%eax
8010443f:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104444:	75 e4                	jne    8010442a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104446:	c7 45 08 20 ad 14 80 	movl   $0x8014ad20,0x8(%ebp)
}
8010444d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104450:	c9                   	leave  
  release(&ptable.lock);
80104451:	e9 ea 03 00 00       	jmp    80104840 <release>
80104456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010445d:	8d 76 00             	lea    0x0(%esi),%esi

80104460 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	53                   	push   %ebx
80104464:	83 ec 10             	sub    $0x10,%esp
80104467:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010446a:	68 20 ad 14 80       	push   $0x8014ad20
8010446f:	e8 2c 04 00 00       	call   801048a0 <acquire>
80104474:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104477:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
8010447c:	eb 0c                	jmp    8010448a <kill+0x2a>
8010447e:	66 90                	xchg   %ax,%ax
80104480:	83 c0 7c             	add    $0x7c,%eax
80104483:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104488:	74 36                	je     801044c0 <kill+0x60>
    if(p->pid == pid){
8010448a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010448d:	75 f1                	jne    80104480 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010448f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104493:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010449a:	75 07                	jne    801044a3 <kill+0x43>
        p->state = RUNNABLE;
8010449c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801044a3:	83 ec 0c             	sub    $0xc,%esp
801044a6:	68 20 ad 14 80       	push   $0x8014ad20
801044ab:	e8 90 03 00 00       	call   80104840 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801044b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801044b3:	83 c4 10             	add    $0x10,%esp
801044b6:	31 c0                	xor    %eax,%eax
}
801044b8:	c9                   	leave  
801044b9:	c3                   	ret    
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801044c0:	83 ec 0c             	sub    $0xc,%esp
801044c3:	68 20 ad 14 80       	push   $0x8014ad20
801044c8:	e8 73 03 00 00       	call   80104840 <release>
}
801044cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801044d0:	83 c4 10             	add    $0x10,%esp
801044d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044d8:	c9                   	leave  
801044d9:	c3                   	ret    
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	57                   	push   %edi
801044e4:	56                   	push   %esi
801044e5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801044e8:	53                   	push   %ebx
801044e9:	bb c0 ad 14 80       	mov    $0x8014adc0,%ebx
801044ee:	83 ec 3c             	sub    $0x3c,%esp
801044f1:	eb 24                	jmp    80104517 <procdump+0x37>
801044f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044f7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801044f8:	83 ec 0c             	sub    $0xc,%esp
801044fb:	68 57 83 10 80       	push   $0x80108357
80104500:	e8 9b c1 ff ff       	call   801006a0 <cprintf>
80104505:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104508:	83 c3 7c             	add    $0x7c,%ebx
8010450b:	81 fb c0 cc 14 80    	cmp    $0x8014ccc0,%ebx
80104511:	0f 84 81 00 00 00    	je     80104598 <procdump+0xb8>
    if(p->state == UNUSED)
80104517:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010451a:	85 c0                	test   %eax,%eax
8010451c:	74 ea                	je     80104508 <procdump+0x28>
      state = "???";
8010451e:	ba 42 7e 10 80       	mov    $0x80107e42,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104523:	83 f8 05             	cmp    $0x5,%eax
80104526:	77 11                	ja     80104539 <procdump+0x59>
80104528:	8b 14 85 98 7f 10 80 	mov    -0x7fef8068(,%eax,4),%edx
      state = "???";
8010452f:	b8 42 7e 10 80       	mov    $0x80107e42,%eax
80104534:	85 d2                	test   %edx,%edx
80104536:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104539:	53                   	push   %ebx
8010453a:	52                   	push   %edx
8010453b:	ff 73 a4             	push   -0x5c(%ebx)
8010453e:	68 46 7e 10 80       	push   $0x80107e46
80104543:	e8 58 c1 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104548:	83 c4 10             	add    $0x10,%esp
8010454b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010454f:	75 a7                	jne    801044f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104551:	83 ec 08             	sub    $0x8,%esp
80104554:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104557:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010455a:	50                   	push   %eax
8010455b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010455e:	8b 40 0c             	mov    0xc(%eax),%eax
80104561:	83 c0 08             	add    $0x8,%eax
80104564:	50                   	push   %eax
80104565:	e8 86 01 00 00       	call   801046f0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010456a:	83 c4 10             	add    $0x10,%esp
8010456d:	8d 76 00             	lea    0x0(%esi),%esi
80104570:	8b 17                	mov    (%edi),%edx
80104572:	85 d2                	test   %edx,%edx
80104574:	74 82                	je     801044f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104576:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104579:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010457c:	52                   	push   %edx
8010457d:	68 61 78 10 80       	push   $0x80107861
80104582:	e8 19 c1 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104587:	83 c4 10             	add    $0x10,%esp
8010458a:	39 fe                	cmp    %edi,%esi
8010458c:	75 e2                	jne    80104570 <procdump+0x90>
8010458e:	e9 65 ff ff ff       	jmp    801044f8 <procdump+0x18>
80104593:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104597:	90                   	nop
  }
}
80104598:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010459b:	5b                   	pop    %ebx
8010459c:	5e                   	pop    %esi
8010459d:	5f                   	pop    %edi
8010459e:	5d                   	pop    %ebp
8010459f:	c3                   	ret    

801045a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	83 ec 0c             	sub    $0xc,%esp
801045a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801045aa:	68 b0 7f 10 80       	push   $0x80107fb0
801045af:	8d 43 04             	lea    0x4(%ebx),%eax
801045b2:	50                   	push   %eax
801045b3:	e8 18 01 00 00       	call   801046d0 <initlock>
  lk->name = name;
801045b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801045bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801045c1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801045c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801045cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801045ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045d1:	c9                   	leave  
801045d2:	c3                   	ret    
801045d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	56                   	push   %esi
801045e4:	53                   	push   %ebx
801045e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045e8:	8d 73 04             	lea    0x4(%ebx),%esi
801045eb:	83 ec 0c             	sub    $0xc,%esp
801045ee:	56                   	push   %esi
801045ef:	e8 ac 02 00 00       	call   801048a0 <acquire>
  while (lk->locked) {
801045f4:	8b 13                	mov    (%ebx),%edx
801045f6:	83 c4 10             	add    $0x10,%esp
801045f9:	85 d2                	test   %edx,%edx
801045fb:	74 16                	je     80104613 <acquiresleep+0x33>
801045fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104600:	83 ec 08             	sub    $0x8,%esp
80104603:	56                   	push   %esi
80104604:	53                   	push   %ebx
80104605:	e8 36 fd ff ff       	call   80104340 <sleep>
  while (lk->locked) {
8010460a:	8b 03                	mov    (%ebx),%eax
8010460c:	83 c4 10             	add    $0x10,%esp
8010460f:	85 c0                	test   %eax,%eax
80104611:	75 ed                	jne    80104600 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104613:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104619:	e8 b2 f4 ff ff       	call   80103ad0 <myproc>
8010461e:	8b 40 10             	mov    0x10(%eax),%eax
80104621:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104624:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104627:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010462a:	5b                   	pop    %ebx
8010462b:	5e                   	pop    %esi
8010462c:	5d                   	pop    %ebp
  release(&lk->lk);
8010462d:	e9 0e 02 00 00       	jmp    80104840 <release>
80104632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104640 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
80104645:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104648:	8d 73 04             	lea    0x4(%ebx),%esi
8010464b:	83 ec 0c             	sub    $0xc,%esp
8010464e:	56                   	push   %esi
8010464f:	e8 4c 02 00 00       	call   801048a0 <acquire>
  lk->locked = 0;
80104654:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010465a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104661:	89 1c 24             	mov    %ebx,(%esp)
80104664:	e8 97 fd ff ff       	call   80104400 <wakeup>
  release(&lk->lk);
80104669:	89 75 08             	mov    %esi,0x8(%ebp)
8010466c:	83 c4 10             	add    $0x10,%esp
}
8010466f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104672:	5b                   	pop    %ebx
80104673:	5e                   	pop    %esi
80104674:	5d                   	pop    %ebp
  release(&lk->lk);
80104675:	e9 c6 01 00 00       	jmp    80104840 <release>
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104680 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	57                   	push   %edi
80104684:	31 ff                	xor    %edi,%edi
80104686:	56                   	push   %esi
80104687:	53                   	push   %ebx
80104688:	83 ec 18             	sub    $0x18,%esp
8010468b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010468e:	8d 73 04             	lea    0x4(%ebx),%esi
80104691:	56                   	push   %esi
80104692:	e8 09 02 00 00       	call   801048a0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104697:	8b 03                	mov    (%ebx),%eax
80104699:	83 c4 10             	add    $0x10,%esp
8010469c:	85 c0                	test   %eax,%eax
8010469e:	75 18                	jne    801046b8 <holdingsleep+0x38>
  release(&lk->lk);
801046a0:	83 ec 0c             	sub    $0xc,%esp
801046a3:	56                   	push   %esi
801046a4:	e8 97 01 00 00       	call   80104840 <release>
  return r;
}
801046a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046ac:	89 f8                	mov    %edi,%eax
801046ae:	5b                   	pop    %ebx
801046af:	5e                   	pop    %esi
801046b0:	5f                   	pop    %edi
801046b1:	5d                   	pop    %ebp
801046b2:	c3                   	ret    
801046b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046b7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801046b8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801046bb:	e8 10 f4 ff ff       	call   80103ad0 <myproc>
801046c0:	39 58 10             	cmp    %ebx,0x10(%eax)
801046c3:	0f 94 c0             	sete   %al
801046c6:	0f b6 c0             	movzbl %al,%eax
801046c9:	89 c7                	mov    %eax,%edi
801046cb:	eb d3                	jmp    801046a0 <holdingsleep+0x20>
801046cd:	66 90                	xchg   %ax,%ax
801046cf:	90                   	nop

801046d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801046d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801046d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801046df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801046e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801046e9:	5d                   	pop    %ebp
801046ea:	c3                   	ret    
801046eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046ef:	90                   	nop

801046f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046f0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046f1:	31 d2                	xor    %edx,%edx
{
801046f3:	89 e5                	mov    %esp,%ebp
801046f5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801046f6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801046f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046fc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801046ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104700:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104706:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010470c:	77 1a                	ja     80104728 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010470e:	8b 58 04             	mov    0x4(%eax),%ebx
80104711:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104714:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104717:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104719:	83 fa 0a             	cmp    $0xa,%edx
8010471c:	75 e2                	jne    80104700 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010471e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104721:	c9                   	leave  
80104722:	c3                   	ret    
80104723:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104727:	90                   	nop
  for(; i < 10; i++)
80104728:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010472b:	8d 51 28             	lea    0x28(%ecx),%edx
8010472e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104730:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104736:	83 c0 04             	add    $0x4,%eax
80104739:	39 d0                	cmp    %edx,%eax
8010473b:	75 f3                	jne    80104730 <getcallerpcs+0x40>
}
8010473d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104740:	c9                   	leave  
80104741:	c3                   	ret    
80104742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104750 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	53                   	push   %ebx
80104754:	83 ec 04             	sub    $0x4,%esp
80104757:	9c                   	pushf  
80104758:	5b                   	pop    %ebx
  asm volatile("cli");
80104759:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010475a:	e8 f1 f2 ff ff       	call   80103a50 <mycpu>
8010475f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104765:	85 c0                	test   %eax,%eax
80104767:	74 17                	je     80104780 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104769:	e8 e2 f2 ff ff       	call   80103a50 <mycpu>
8010476e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104775:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104778:	c9                   	leave  
80104779:	c3                   	ret    
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104780:	e8 cb f2 ff ff       	call   80103a50 <mycpu>
80104785:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010478b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104791:	eb d6                	jmp    80104769 <pushcli+0x19>
80104793:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047a0 <popcli>:

void
popcli(void)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047a6:	9c                   	pushf  
801047a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801047a8:	f6 c4 02             	test   $0x2,%ah
801047ab:	75 35                	jne    801047e2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801047ad:	e8 9e f2 ff ff       	call   80103a50 <mycpu>
801047b2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801047b9:	78 34                	js     801047ef <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047bb:	e8 90 f2 ff ff       	call   80103a50 <mycpu>
801047c0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801047c6:	85 d2                	test   %edx,%edx
801047c8:	74 06                	je     801047d0 <popcli+0x30>
    sti();
}
801047ca:	c9                   	leave  
801047cb:	c3                   	ret    
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047d0:	e8 7b f2 ff ff       	call   80103a50 <mycpu>
801047d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801047db:	85 c0                	test   %eax,%eax
801047dd:	74 eb                	je     801047ca <popcli+0x2a>
  asm volatile("sti");
801047df:	fb                   	sti    
}
801047e0:	c9                   	leave  
801047e1:	c3                   	ret    
    panic("popcli - interruptible");
801047e2:	83 ec 0c             	sub    $0xc,%esp
801047e5:	68 bb 7f 10 80       	push   $0x80107fbb
801047ea:	e8 91 bb ff ff       	call   80100380 <panic>
    panic("popcli");
801047ef:	83 ec 0c             	sub    $0xc,%esp
801047f2:	68 d2 7f 10 80       	push   $0x80107fd2
801047f7:	e8 84 bb ff ff       	call   80100380 <panic>
801047fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104800 <holding>:
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
80104805:	8b 75 08             	mov    0x8(%ebp),%esi
80104808:	31 db                	xor    %ebx,%ebx
  pushcli();
8010480a:	e8 41 ff ff ff       	call   80104750 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010480f:	8b 06                	mov    (%esi),%eax
80104811:	85 c0                	test   %eax,%eax
80104813:	75 0b                	jne    80104820 <holding+0x20>
  popcli();
80104815:	e8 86 ff ff ff       	call   801047a0 <popcli>
}
8010481a:	89 d8                	mov    %ebx,%eax
8010481c:	5b                   	pop    %ebx
8010481d:	5e                   	pop    %esi
8010481e:	5d                   	pop    %ebp
8010481f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104820:	8b 5e 08             	mov    0x8(%esi),%ebx
80104823:	e8 28 f2 ff ff       	call   80103a50 <mycpu>
80104828:	39 c3                	cmp    %eax,%ebx
8010482a:	0f 94 c3             	sete   %bl
  popcli();
8010482d:	e8 6e ff ff ff       	call   801047a0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104832:	0f b6 db             	movzbl %bl,%ebx
}
80104835:	89 d8                	mov    %ebx,%eax
80104837:	5b                   	pop    %ebx
80104838:	5e                   	pop    %esi
80104839:	5d                   	pop    %ebp
8010483a:	c3                   	ret    
8010483b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010483f:	90                   	nop

80104840 <release>:
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	53                   	push   %ebx
80104845:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104848:	e8 03 ff ff ff       	call   80104750 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010484d:	8b 03                	mov    (%ebx),%eax
8010484f:	85 c0                	test   %eax,%eax
80104851:	75 15                	jne    80104868 <release+0x28>
  popcli();
80104853:	e8 48 ff ff ff       	call   801047a0 <popcli>
    panic("release");
80104858:	83 ec 0c             	sub    $0xc,%esp
8010485b:	68 d9 7f 10 80       	push   $0x80107fd9
80104860:	e8 1b bb ff ff       	call   80100380 <panic>
80104865:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104868:	8b 73 08             	mov    0x8(%ebx),%esi
8010486b:	e8 e0 f1 ff ff       	call   80103a50 <mycpu>
80104870:	39 c6                	cmp    %eax,%esi
80104872:	75 df                	jne    80104853 <release+0x13>
  popcli();
80104874:	e8 27 ff ff ff       	call   801047a0 <popcli>
  lk->pcs[0] = 0;
80104879:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104880:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104887:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010488c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104892:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104895:	5b                   	pop    %ebx
80104896:	5e                   	pop    %esi
80104897:	5d                   	pop    %ebp
  popcli();
80104898:	e9 03 ff ff ff       	jmp    801047a0 <popcli>
8010489d:	8d 76 00             	lea    0x0(%esi),%esi

801048a0 <acquire>:
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	53                   	push   %ebx
801048a4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801048a7:	e8 a4 fe ff ff       	call   80104750 <pushcli>
  if(holding(lk))
801048ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801048af:	e8 9c fe ff ff       	call   80104750 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801048b4:	8b 03                	mov    (%ebx),%eax
801048b6:	85 c0                	test   %eax,%eax
801048b8:	75 7e                	jne    80104938 <acquire+0x98>
  popcli();
801048ba:	e8 e1 fe ff ff       	call   801047a0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801048bf:	b9 01 00 00 00       	mov    $0x1,%ecx
801048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801048c8:	8b 55 08             	mov    0x8(%ebp),%edx
801048cb:	89 c8                	mov    %ecx,%eax
801048cd:	f0 87 02             	lock xchg %eax,(%edx)
801048d0:	85 c0                	test   %eax,%eax
801048d2:	75 f4                	jne    801048c8 <acquire+0x28>
  __sync_synchronize();
801048d4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801048d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048dc:	e8 6f f1 ff ff       	call   80103a50 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801048e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801048e4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801048e6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801048e9:	31 c0                	xor    %eax,%eax
801048eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048f0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801048f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048fc:	77 1a                	ja     80104918 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801048fe:	8b 5a 04             	mov    0x4(%edx),%ebx
80104901:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104905:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104908:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010490a:	83 f8 0a             	cmp    $0xa,%eax
8010490d:	75 e1                	jne    801048f0 <acquire+0x50>
}
8010490f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104912:	c9                   	leave  
80104913:	c3                   	ret    
80104914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104918:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010491c:	8d 51 34             	lea    0x34(%ecx),%edx
8010491f:	90                   	nop
    pcs[i] = 0;
80104920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104926:	83 c0 04             	add    $0x4,%eax
80104929:	39 c2                	cmp    %eax,%edx
8010492b:	75 f3                	jne    80104920 <acquire+0x80>
}
8010492d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104930:	c9                   	leave  
80104931:	c3                   	ret    
80104932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104938:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010493b:	e8 10 f1 ff ff       	call   80103a50 <mycpu>
80104940:	39 c3                	cmp    %eax,%ebx
80104942:	0f 85 72 ff ff ff    	jne    801048ba <acquire+0x1a>
  popcli();
80104948:	e8 53 fe ff ff       	call   801047a0 <popcli>
    panic("acquire");
8010494d:	83 ec 0c             	sub    $0xc,%esp
80104950:	68 e1 7f 10 80       	push   $0x80107fe1
80104955:	e8 26 ba ff ff       	call   80100380 <panic>
8010495a:	66 90                	xchg   %ax,%ax
8010495c:	66 90                	xchg   %ax,%ax
8010495e:	66 90                	xchg   %ax,%ax

80104960 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	57                   	push   %edi
80104964:	8b 55 08             	mov    0x8(%ebp),%edx
80104967:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010496a:	53                   	push   %ebx
8010496b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010496e:	89 d7                	mov    %edx,%edi
80104970:	09 cf                	or     %ecx,%edi
80104972:	83 e7 03             	and    $0x3,%edi
80104975:	75 29                	jne    801049a0 <memset+0x40>
    c &= 0xFF;
80104977:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010497a:	c1 e0 18             	shl    $0x18,%eax
8010497d:	89 fb                	mov    %edi,%ebx
8010497f:	c1 e9 02             	shr    $0x2,%ecx
80104982:	c1 e3 10             	shl    $0x10,%ebx
80104985:	09 d8                	or     %ebx,%eax
80104987:	09 f8                	or     %edi,%eax
80104989:	c1 e7 08             	shl    $0x8,%edi
8010498c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010498e:	89 d7                	mov    %edx,%edi
80104990:	fc                   	cld    
80104991:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104993:	5b                   	pop    %ebx
80104994:	89 d0                	mov    %edx,%eax
80104996:	5f                   	pop    %edi
80104997:	5d                   	pop    %ebp
80104998:	c3                   	ret    
80104999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801049a0:	89 d7                	mov    %edx,%edi
801049a2:	fc                   	cld    
801049a3:	f3 aa                	rep stos %al,%es:(%edi)
801049a5:	5b                   	pop    %ebx
801049a6:	89 d0                	mov    %edx,%eax
801049a8:	5f                   	pop    %edi
801049a9:	5d                   	pop    %ebp
801049aa:	c3                   	ret    
801049ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049af:	90                   	nop

801049b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	8b 75 10             	mov    0x10(%ebp),%esi
801049b7:	8b 55 08             	mov    0x8(%ebp),%edx
801049ba:	53                   	push   %ebx
801049bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801049be:	85 f6                	test   %esi,%esi
801049c0:	74 2e                	je     801049f0 <memcmp+0x40>
801049c2:	01 c6                	add    %eax,%esi
801049c4:	eb 14                	jmp    801049da <memcmp+0x2a>
801049c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049cd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801049d0:	83 c0 01             	add    $0x1,%eax
801049d3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801049d6:	39 f0                	cmp    %esi,%eax
801049d8:	74 16                	je     801049f0 <memcmp+0x40>
    if(*s1 != *s2)
801049da:	0f b6 0a             	movzbl (%edx),%ecx
801049dd:	0f b6 18             	movzbl (%eax),%ebx
801049e0:	38 d9                	cmp    %bl,%cl
801049e2:	74 ec                	je     801049d0 <memcmp+0x20>
      return *s1 - *s2;
801049e4:	0f b6 c1             	movzbl %cl,%eax
801049e7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801049e9:	5b                   	pop    %ebx
801049ea:	5e                   	pop    %esi
801049eb:	5d                   	pop    %ebp
801049ec:	c3                   	ret    
801049ed:	8d 76 00             	lea    0x0(%esi),%esi
801049f0:	5b                   	pop    %ebx
  return 0;
801049f1:	31 c0                	xor    %eax,%eax
}
801049f3:	5e                   	pop    %esi
801049f4:	5d                   	pop    %ebp
801049f5:	c3                   	ret    
801049f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049fd:	8d 76 00             	lea    0x0(%esi),%esi

80104a00 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	57                   	push   %edi
80104a04:	8b 55 08             	mov    0x8(%ebp),%edx
80104a07:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a0a:	56                   	push   %esi
80104a0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a0e:	39 d6                	cmp    %edx,%esi
80104a10:	73 26                	jae    80104a38 <memmove+0x38>
80104a12:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104a15:	39 fa                	cmp    %edi,%edx
80104a17:	73 1f                	jae    80104a38 <memmove+0x38>
80104a19:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104a1c:	85 c9                	test   %ecx,%ecx
80104a1e:	74 0c                	je     80104a2c <memmove+0x2c>
      *--d = *--s;
80104a20:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a24:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104a27:	83 e8 01             	sub    $0x1,%eax
80104a2a:	73 f4                	jae    80104a20 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a2c:	5e                   	pop    %esi
80104a2d:	89 d0                	mov    %edx,%eax
80104a2f:	5f                   	pop    %edi
80104a30:	5d                   	pop    %ebp
80104a31:	c3                   	ret    
80104a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104a38:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104a3b:	89 d7                	mov    %edx,%edi
80104a3d:	85 c9                	test   %ecx,%ecx
80104a3f:	74 eb                	je     80104a2c <memmove+0x2c>
80104a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104a48:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104a49:	39 c6                	cmp    %eax,%esi
80104a4b:	75 fb                	jne    80104a48 <memmove+0x48>
}
80104a4d:	5e                   	pop    %esi
80104a4e:	89 d0                	mov    %edx,%eax
80104a50:	5f                   	pop    %edi
80104a51:	5d                   	pop    %ebp
80104a52:	c3                   	ret    
80104a53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a60 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104a60:	eb 9e                	jmp    80104a00 <memmove>
80104a62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a70 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	8b 75 10             	mov    0x10(%ebp),%esi
80104a77:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a7a:	53                   	push   %ebx
80104a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104a7e:	85 f6                	test   %esi,%esi
80104a80:	74 2e                	je     80104ab0 <strncmp+0x40>
80104a82:	01 d6                	add    %edx,%esi
80104a84:	eb 18                	jmp    80104a9e <strncmp+0x2e>
80104a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi
80104a90:	38 d8                	cmp    %bl,%al
80104a92:	75 14                	jne    80104aa8 <strncmp+0x38>
    n--, p++, q++;
80104a94:	83 c2 01             	add    $0x1,%edx
80104a97:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a9a:	39 f2                	cmp    %esi,%edx
80104a9c:	74 12                	je     80104ab0 <strncmp+0x40>
80104a9e:	0f b6 01             	movzbl (%ecx),%eax
80104aa1:	0f b6 1a             	movzbl (%edx),%ebx
80104aa4:	84 c0                	test   %al,%al
80104aa6:	75 e8                	jne    80104a90 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104aa8:	29 d8                	sub    %ebx,%eax
}
80104aaa:	5b                   	pop    %ebx
80104aab:	5e                   	pop    %esi
80104aac:	5d                   	pop    %ebp
80104aad:	c3                   	ret    
80104aae:	66 90                	xchg   %ax,%ax
80104ab0:	5b                   	pop    %ebx
    return 0;
80104ab1:	31 c0                	xor    %eax,%eax
}
80104ab3:	5e                   	pop    %esi
80104ab4:	5d                   	pop    %ebp
80104ab5:	c3                   	ret    
80104ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abd:	8d 76 00             	lea    0x0(%esi),%esi

80104ac0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ac8:	53                   	push   %ebx
80104ac9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104acc:	89 f0                	mov    %esi,%eax
80104ace:	eb 15                	jmp    80104ae5 <strncpy+0x25>
80104ad0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104ad4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104ad7:	83 c0 01             	add    $0x1,%eax
80104ada:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104ade:	88 50 ff             	mov    %dl,-0x1(%eax)
80104ae1:	84 d2                	test   %dl,%dl
80104ae3:	74 09                	je     80104aee <strncpy+0x2e>
80104ae5:	89 cb                	mov    %ecx,%ebx
80104ae7:	83 e9 01             	sub    $0x1,%ecx
80104aea:	85 db                	test   %ebx,%ebx
80104aec:	7f e2                	jg     80104ad0 <strncpy+0x10>
    ;
  while(n-- > 0)
80104aee:	89 c2                	mov    %eax,%edx
80104af0:	85 c9                	test   %ecx,%ecx
80104af2:	7e 17                	jle    80104b0b <strncpy+0x4b>
80104af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104af8:	83 c2 01             	add    $0x1,%edx
80104afb:	89 c1                	mov    %eax,%ecx
80104afd:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104b01:	29 d1                	sub    %edx,%ecx
80104b03:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104b07:	85 c9                	test   %ecx,%ecx
80104b09:	7f ed                	jg     80104af8 <strncpy+0x38>
  return os;
}
80104b0b:	5b                   	pop    %ebx
80104b0c:	89 f0                	mov    %esi,%eax
80104b0e:	5e                   	pop    %esi
80104b0f:	5f                   	pop    %edi
80104b10:	5d                   	pop    %ebp
80104b11:	c3                   	ret    
80104b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	8b 55 10             	mov    0x10(%ebp),%edx
80104b27:	8b 75 08             	mov    0x8(%ebp),%esi
80104b2a:	53                   	push   %ebx
80104b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104b2e:	85 d2                	test   %edx,%edx
80104b30:	7e 25                	jle    80104b57 <safestrcpy+0x37>
80104b32:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104b36:	89 f2                	mov    %esi,%edx
80104b38:	eb 16                	jmp    80104b50 <safestrcpy+0x30>
80104b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b40:	0f b6 08             	movzbl (%eax),%ecx
80104b43:	83 c0 01             	add    $0x1,%eax
80104b46:	83 c2 01             	add    $0x1,%edx
80104b49:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b4c:	84 c9                	test   %cl,%cl
80104b4e:	74 04                	je     80104b54 <safestrcpy+0x34>
80104b50:	39 d8                	cmp    %ebx,%eax
80104b52:	75 ec                	jne    80104b40 <safestrcpy+0x20>
    ;
  *s = 0;
80104b54:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104b57:	89 f0                	mov    %esi,%eax
80104b59:	5b                   	pop    %ebx
80104b5a:	5e                   	pop    %esi
80104b5b:	5d                   	pop    %ebp
80104b5c:	c3                   	ret    
80104b5d:	8d 76 00             	lea    0x0(%esi),%esi

80104b60 <strlen>:

int
strlen(const char *s)
{
80104b60:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b61:	31 c0                	xor    %eax,%eax
{
80104b63:	89 e5                	mov    %esp,%ebp
80104b65:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b68:	80 3a 00             	cmpb   $0x0,(%edx)
80104b6b:	74 0c                	je     80104b79 <strlen+0x19>
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi
80104b70:	83 c0 01             	add    $0x1,%eax
80104b73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b77:	75 f7                	jne    80104b70 <strlen+0x10>
    ;
  return n;
}
80104b79:	5d                   	pop    %ebp
80104b7a:	c3                   	ret    

80104b7b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b7b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b7f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104b83:	55                   	push   %ebp
  pushl %ebx
80104b84:	53                   	push   %ebx
  pushl %esi
80104b85:	56                   	push   %esi
  pushl %edi
80104b86:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b87:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b89:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104b8b:	5f                   	pop    %edi
  popl %esi
80104b8c:	5e                   	pop    %esi
  popl %ebx
80104b8d:	5b                   	pop    %ebx
  popl %ebp
80104b8e:	5d                   	pop    %ebp
  ret
80104b8f:	c3                   	ret    

80104b90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	53                   	push   %ebx
80104b94:	83 ec 04             	sub    $0x4,%esp
80104b97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b9a:	e8 31 ef ff ff       	call   80103ad0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b9f:	8b 00                	mov    (%eax),%eax
80104ba1:	39 d8                	cmp    %ebx,%eax
80104ba3:	76 1b                	jbe    80104bc0 <fetchint+0x30>
80104ba5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ba8:	39 d0                	cmp    %edx,%eax
80104baa:	72 14                	jb     80104bc0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104bac:	8b 45 0c             	mov    0xc(%ebp),%eax
80104baf:	8b 13                	mov    (%ebx),%edx
80104bb1:	89 10                	mov    %edx,(%eax)
  return 0;
80104bb3:	31 c0                	xor    %eax,%eax
}
80104bb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bb8:	c9                   	leave  
80104bb9:	c3                   	ret    
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bc5:	eb ee                	jmp    80104bb5 <fetchint+0x25>
80104bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bce:	66 90                	xchg   %ax,%ax

80104bd0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	53                   	push   %ebx
80104bd4:	83 ec 04             	sub    $0x4,%esp
80104bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104bda:	e8 f1 ee ff ff       	call   80103ad0 <myproc>

  if(addr >= curproc->sz)
80104bdf:	39 18                	cmp    %ebx,(%eax)
80104be1:	76 2d                	jbe    80104c10 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104be3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104be6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104be8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104bea:	39 d3                	cmp    %edx,%ebx
80104bec:	73 22                	jae    80104c10 <fetchstr+0x40>
80104bee:	89 d8                	mov    %ebx,%eax
80104bf0:	eb 0d                	jmp    80104bff <fetchstr+0x2f>
80104bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bf8:	83 c0 01             	add    $0x1,%eax
80104bfb:	39 c2                	cmp    %eax,%edx
80104bfd:	76 11                	jbe    80104c10 <fetchstr+0x40>
    if(*s == 0)
80104bff:	80 38 00             	cmpb   $0x0,(%eax)
80104c02:	75 f4                	jne    80104bf8 <fetchstr+0x28>
      return s - *pp;
80104c04:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104c06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c09:	c9                   	leave  
80104c0a:	c3                   	ret    
80104c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c0f:	90                   	nop
80104c10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104c13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c18:	c9                   	leave  
80104c19:	c3                   	ret    
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c25:	e8 a6 ee ff ff       	call   80103ad0 <myproc>
80104c2a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c2d:	8b 40 18             	mov    0x18(%eax),%eax
80104c30:	8b 40 44             	mov    0x44(%eax),%eax
80104c33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c36:	e8 95 ee ff ff       	call   80103ad0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c3b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c3e:	8b 00                	mov    (%eax),%eax
80104c40:	39 c6                	cmp    %eax,%esi
80104c42:	73 1c                	jae    80104c60 <argint+0x40>
80104c44:	8d 53 08             	lea    0x8(%ebx),%edx
80104c47:	39 d0                	cmp    %edx,%eax
80104c49:	72 15                	jb     80104c60 <argint+0x40>
  *ip = *(int*)(addr);
80104c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c4e:	8b 53 04             	mov    0x4(%ebx),%edx
80104c51:	89 10                	mov    %edx,(%eax)
  return 0;
80104c53:	31 c0                	xor    %eax,%eax
}
80104c55:	5b                   	pop    %ebx
80104c56:	5e                   	pop    %esi
80104c57:	5d                   	pop    %ebp
80104c58:	c3                   	ret    
80104c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c65:	eb ee                	jmp    80104c55 <argint+0x35>
80104c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6e:	66 90                	xchg   %ax,%ax

80104c70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	57                   	push   %edi
80104c74:	56                   	push   %esi
80104c75:	53                   	push   %ebx
80104c76:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104c79:	e8 52 ee ff ff       	call   80103ad0 <myproc>
80104c7e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c80:	e8 4b ee ff ff       	call   80103ad0 <myproc>
80104c85:	8b 55 08             	mov    0x8(%ebp),%edx
80104c88:	8b 40 18             	mov    0x18(%eax),%eax
80104c8b:	8b 40 44             	mov    0x44(%eax),%eax
80104c8e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c91:	e8 3a ee ff ff       	call   80103ad0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c96:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c99:	8b 00                	mov    (%eax),%eax
80104c9b:	39 c7                	cmp    %eax,%edi
80104c9d:	73 31                	jae    80104cd0 <argptr+0x60>
80104c9f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104ca2:	39 c8                	cmp    %ecx,%eax
80104ca4:	72 2a                	jb     80104cd0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ca6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104ca9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104cac:	85 d2                	test   %edx,%edx
80104cae:	78 20                	js     80104cd0 <argptr+0x60>
80104cb0:	8b 16                	mov    (%esi),%edx
80104cb2:	39 c2                	cmp    %eax,%edx
80104cb4:	76 1a                	jbe    80104cd0 <argptr+0x60>
80104cb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104cb9:	01 c3                	add    %eax,%ebx
80104cbb:	39 da                	cmp    %ebx,%edx
80104cbd:	72 11                	jb     80104cd0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cc2:	89 02                	mov    %eax,(%edx)
  return 0;
80104cc4:	31 c0                	xor    %eax,%eax
}
80104cc6:	83 c4 0c             	add    $0xc,%esp
80104cc9:	5b                   	pop    %ebx
80104cca:	5e                   	pop    %esi
80104ccb:	5f                   	pop    %edi
80104ccc:	5d                   	pop    %ebp
80104ccd:	c3                   	ret    
80104cce:	66 90                	xchg   %ax,%ax
    return -1;
80104cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cd5:	eb ef                	jmp    80104cc6 <argptr+0x56>
80104cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cde:	66 90                	xchg   %ax,%ax

80104ce0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ce5:	e8 e6 ed ff ff       	call   80103ad0 <myproc>
80104cea:	8b 55 08             	mov    0x8(%ebp),%edx
80104ced:	8b 40 18             	mov    0x18(%eax),%eax
80104cf0:	8b 40 44             	mov    0x44(%eax),%eax
80104cf3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104cf6:	e8 d5 ed ff ff       	call   80103ad0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cfb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cfe:	8b 00                	mov    (%eax),%eax
80104d00:	39 c6                	cmp    %eax,%esi
80104d02:	73 44                	jae    80104d48 <argstr+0x68>
80104d04:	8d 53 08             	lea    0x8(%ebx),%edx
80104d07:	39 d0                	cmp    %edx,%eax
80104d09:	72 3d                	jb     80104d48 <argstr+0x68>
  *ip = *(int*)(addr);
80104d0b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104d0e:	e8 bd ed ff ff       	call   80103ad0 <myproc>
  if(addr >= curproc->sz)
80104d13:	3b 18                	cmp    (%eax),%ebx
80104d15:	73 31                	jae    80104d48 <argstr+0x68>
  *pp = (char*)addr;
80104d17:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d1a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104d1c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104d1e:	39 d3                	cmp    %edx,%ebx
80104d20:	73 26                	jae    80104d48 <argstr+0x68>
80104d22:	89 d8                	mov    %ebx,%eax
80104d24:	eb 11                	jmp    80104d37 <argstr+0x57>
80104d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2d:	8d 76 00             	lea    0x0(%esi),%esi
80104d30:	83 c0 01             	add    $0x1,%eax
80104d33:	39 c2                	cmp    %eax,%edx
80104d35:	76 11                	jbe    80104d48 <argstr+0x68>
    if(*s == 0)
80104d37:	80 38 00             	cmpb   $0x0,(%eax)
80104d3a:	75 f4                	jne    80104d30 <argstr+0x50>
      return s - *pp;
80104d3c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104d3e:	5b                   	pop    %ebx
80104d3f:	5e                   	pop    %esi
80104d40:	5d                   	pop    %ebp
80104d41:	c3                   	ret    
80104d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d48:	5b                   	pop    %ebx
    return -1;
80104d49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d4e:	5e                   	pop    %esi
80104d4f:	5d                   	pop    %ebp
80104d50:	c3                   	ret    
80104d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5f:	90                   	nop

80104d60 <syscall>:
[SYS_forkcow]  sys_forkcow,
};

void
syscall(void)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	53                   	push   %ebx
80104d64:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d67:	e8 64 ed ff ff       	call   80103ad0 <myproc>
80104d6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d6e:	8b 40 18             	mov    0x18(%eax),%eax
80104d71:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d74:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d77:	83 fa 18             	cmp    $0x18,%edx
80104d7a:	77 24                	ja     80104da0 <syscall+0x40>
80104d7c:	8b 14 85 20 80 10 80 	mov    -0x7fef7fe0(,%eax,4),%edx
80104d83:	85 d2                	test   %edx,%edx
80104d85:	74 19                	je     80104da0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104d87:	ff d2                	call   *%edx
80104d89:	89 c2                	mov    %eax,%edx
80104d8b:	8b 43 18             	mov    0x18(%ebx),%eax
80104d8e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d94:	c9                   	leave  
80104d95:	c3                   	ret    
80104d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104da0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104da1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104da4:	50                   	push   %eax
80104da5:	ff 73 10             	push   0x10(%ebx)
80104da8:	68 e9 7f 10 80       	push   $0x80107fe9
80104dad:	e8 ee b8 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104db2:	8b 43 18             	mov    0x18(%ebx),%eax
80104db5:	83 c4 10             	add    $0x10,%esp
80104db8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104dbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc2:	c9                   	leave  
80104dc3:	c3                   	ret    
80104dc4:	66 90                	xchg   %ax,%ax
80104dc6:	66 90                	xchg   %ax,%ax
80104dc8:	66 90                	xchg   %ax,%ax
80104dca:	66 90                	xchg   %ax,%ax
80104dcc:	66 90                	xchg   %ax,%ax
80104dce:	66 90                	xchg   %ax,%ax

80104dd0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104dd5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104dd8:	53                   	push   %ebx
80104dd9:	83 ec 34             	sub    $0x34,%esp
80104ddc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104ddf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104de2:	57                   	push   %edi
80104de3:	50                   	push   %eax
{
80104de4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104de7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104dea:	e8 d1 d2 ff ff       	call   801020c0 <nameiparent>
80104def:	83 c4 10             	add    $0x10,%esp
80104df2:	85 c0                	test   %eax,%eax
80104df4:	0f 84 46 01 00 00    	je     80104f40 <create+0x170>
    return 0;
  ilock(dp);
80104dfa:	83 ec 0c             	sub    $0xc,%esp
80104dfd:	89 c3                	mov    %eax,%ebx
80104dff:	50                   	push   %eax
80104e00:	e8 7b c9 ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104e05:	83 c4 0c             	add    $0xc,%esp
80104e08:	6a 00                	push   $0x0
80104e0a:	57                   	push   %edi
80104e0b:	53                   	push   %ebx
80104e0c:	e8 cf ce ff ff       	call   80101ce0 <dirlookup>
80104e11:	83 c4 10             	add    $0x10,%esp
80104e14:	89 c6                	mov    %eax,%esi
80104e16:	85 c0                	test   %eax,%eax
80104e18:	74 56                	je     80104e70 <create+0xa0>
    iunlockput(dp);
80104e1a:	83 ec 0c             	sub    $0xc,%esp
80104e1d:	53                   	push   %ebx
80104e1e:	e8 ed cb ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104e23:	89 34 24             	mov    %esi,(%esp)
80104e26:	e8 55 c9 ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e2b:	83 c4 10             	add    $0x10,%esp
80104e2e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104e33:	75 1b                	jne    80104e50 <create+0x80>
80104e35:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104e3a:	75 14                	jne    80104e50 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e3f:	89 f0                	mov    %esi,%eax
80104e41:	5b                   	pop    %ebx
80104e42:	5e                   	pop    %esi
80104e43:	5f                   	pop    %edi
80104e44:	5d                   	pop    %ebp
80104e45:	c3                   	ret    
80104e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e4d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104e50:	83 ec 0c             	sub    $0xc,%esp
80104e53:	56                   	push   %esi
    return 0;
80104e54:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104e56:	e8 b5 cb ff ff       	call   80101a10 <iunlockput>
    return 0;
80104e5b:	83 c4 10             	add    $0x10,%esp
}
80104e5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e61:	89 f0                	mov    %esi,%eax
80104e63:	5b                   	pop    %ebx
80104e64:	5e                   	pop    %esi
80104e65:	5f                   	pop    %edi
80104e66:	5d                   	pop    %ebp
80104e67:	c3                   	ret    
80104e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104e70:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e74:	83 ec 08             	sub    $0x8,%esp
80104e77:	50                   	push   %eax
80104e78:	ff 33                	push   (%ebx)
80104e7a:	e8 91 c7 ff ff       	call   80101610 <ialloc>
80104e7f:	83 c4 10             	add    $0x10,%esp
80104e82:	89 c6                	mov    %eax,%esi
80104e84:	85 c0                	test   %eax,%eax
80104e86:	0f 84 cd 00 00 00    	je     80104f59 <create+0x189>
  ilock(ip);
80104e8c:	83 ec 0c             	sub    $0xc,%esp
80104e8f:	50                   	push   %eax
80104e90:	e8 eb c8 ff ff       	call   80101780 <ilock>
  ip->major = major;
80104e95:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e99:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104e9d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ea1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104ea5:	b8 01 00 00 00       	mov    $0x1,%eax
80104eaa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104eae:	89 34 24             	mov    %esi,(%esp)
80104eb1:	e8 1a c8 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104eb6:	83 c4 10             	add    $0x10,%esp
80104eb9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104ebe:	74 30                	je     80104ef0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104ec0:	83 ec 04             	sub    $0x4,%esp
80104ec3:	ff 76 04             	push   0x4(%esi)
80104ec6:	57                   	push   %edi
80104ec7:	53                   	push   %ebx
80104ec8:	e8 13 d1 ff ff       	call   80101fe0 <dirlink>
80104ecd:	83 c4 10             	add    $0x10,%esp
80104ed0:	85 c0                	test   %eax,%eax
80104ed2:	78 78                	js     80104f4c <create+0x17c>
  iunlockput(dp);
80104ed4:	83 ec 0c             	sub    $0xc,%esp
80104ed7:	53                   	push   %ebx
80104ed8:	e8 33 cb ff ff       	call   80101a10 <iunlockput>
  return ip;
80104edd:	83 c4 10             	add    $0x10,%esp
}
80104ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ee3:	89 f0                	mov    %esi,%eax
80104ee5:	5b                   	pop    %ebx
80104ee6:	5e                   	pop    %esi
80104ee7:	5f                   	pop    %edi
80104ee8:	5d                   	pop    %ebp
80104ee9:	c3                   	ret    
80104eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104ef0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104ef3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ef8:	53                   	push   %ebx
80104ef9:	e8 d2 c7 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104efe:	83 c4 0c             	add    $0xc,%esp
80104f01:	ff 76 04             	push   0x4(%esi)
80104f04:	68 a4 80 10 80       	push   $0x801080a4
80104f09:	56                   	push   %esi
80104f0a:	e8 d1 d0 ff ff       	call   80101fe0 <dirlink>
80104f0f:	83 c4 10             	add    $0x10,%esp
80104f12:	85 c0                	test   %eax,%eax
80104f14:	78 18                	js     80104f2e <create+0x15e>
80104f16:	83 ec 04             	sub    $0x4,%esp
80104f19:	ff 73 04             	push   0x4(%ebx)
80104f1c:	68 a3 80 10 80       	push   $0x801080a3
80104f21:	56                   	push   %esi
80104f22:	e8 b9 d0 ff ff       	call   80101fe0 <dirlink>
80104f27:	83 c4 10             	add    $0x10,%esp
80104f2a:	85 c0                	test   %eax,%eax
80104f2c:	79 92                	jns    80104ec0 <create+0xf0>
      panic("create dots");
80104f2e:	83 ec 0c             	sub    $0xc,%esp
80104f31:	68 97 80 10 80       	push   $0x80108097
80104f36:	e8 45 b4 ff ff       	call   80100380 <panic>
80104f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f3f:	90                   	nop
}
80104f40:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104f43:	31 f6                	xor    %esi,%esi
}
80104f45:	5b                   	pop    %ebx
80104f46:	89 f0                	mov    %esi,%eax
80104f48:	5e                   	pop    %esi
80104f49:	5f                   	pop    %edi
80104f4a:	5d                   	pop    %ebp
80104f4b:	c3                   	ret    
    panic("create: dirlink");
80104f4c:	83 ec 0c             	sub    $0xc,%esp
80104f4f:	68 a6 80 10 80       	push   $0x801080a6
80104f54:	e8 27 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104f59:	83 ec 0c             	sub    $0xc,%esp
80104f5c:	68 88 80 10 80       	push   $0x80108088
80104f61:	e8 1a b4 ff ff       	call   80100380 <panic>
80104f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi

80104f70 <sys_dup>:
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	56                   	push   %esi
80104f74:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f75:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f78:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f7b:	50                   	push   %eax
80104f7c:	6a 00                	push   $0x0
80104f7e:	e8 9d fc ff ff       	call   80104c20 <argint>
80104f83:	83 c4 10             	add    $0x10,%esp
80104f86:	85 c0                	test   %eax,%eax
80104f88:	78 36                	js     80104fc0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f8a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f8e:	77 30                	ja     80104fc0 <sys_dup+0x50>
80104f90:	e8 3b eb ff ff       	call   80103ad0 <myproc>
80104f95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f98:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f9c:	85 f6                	test   %esi,%esi
80104f9e:	74 20                	je     80104fc0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104fa0:	e8 2b eb ff ff       	call   80103ad0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104fa5:	31 db                	xor    %ebx,%ebx
80104fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104fb0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104fb4:	85 d2                	test   %edx,%edx
80104fb6:	74 18                	je     80104fd0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104fb8:	83 c3 01             	add    $0x1,%ebx
80104fbb:	83 fb 10             	cmp    $0x10,%ebx
80104fbe:	75 f0                	jne    80104fb0 <sys_dup+0x40>
}
80104fc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104fc3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104fc8:	89 d8                	mov    %ebx,%eax
80104fca:	5b                   	pop    %ebx
80104fcb:	5e                   	pop    %esi
80104fcc:	5d                   	pop    %ebp
80104fcd:	c3                   	ret    
80104fce:	66 90                	xchg   %ax,%ax
  filedup(f);
80104fd0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104fd3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104fd7:	56                   	push   %esi
80104fd8:	e8 c3 be ff ff       	call   80100ea0 <filedup>
  return fd;
80104fdd:	83 c4 10             	add    $0x10,%esp
}
80104fe0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fe3:	89 d8                	mov    %ebx,%eax
80104fe5:	5b                   	pop    %ebx
80104fe6:	5e                   	pop    %esi
80104fe7:	5d                   	pop    %ebp
80104fe8:	c3                   	ret    
80104fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ff0 <sys_read>:
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ff5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ff8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ffb:	53                   	push   %ebx
80104ffc:	6a 00                	push   $0x0
80104ffe:	e8 1d fc ff ff       	call   80104c20 <argint>
80105003:	83 c4 10             	add    $0x10,%esp
80105006:	85 c0                	test   %eax,%eax
80105008:	78 5e                	js     80105068 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010500a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010500e:	77 58                	ja     80105068 <sys_read+0x78>
80105010:	e8 bb ea ff ff       	call   80103ad0 <myproc>
80105015:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105018:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010501c:	85 f6                	test   %esi,%esi
8010501e:	74 48                	je     80105068 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105020:	83 ec 08             	sub    $0x8,%esp
80105023:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105026:	50                   	push   %eax
80105027:	6a 02                	push   $0x2
80105029:	e8 f2 fb ff ff       	call   80104c20 <argint>
8010502e:	83 c4 10             	add    $0x10,%esp
80105031:	85 c0                	test   %eax,%eax
80105033:	78 33                	js     80105068 <sys_read+0x78>
80105035:	83 ec 04             	sub    $0x4,%esp
80105038:	ff 75 f0             	push   -0x10(%ebp)
8010503b:	53                   	push   %ebx
8010503c:	6a 01                	push   $0x1
8010503e:	e8 2d fc ff ff       	call   80104c70 <argptr>
80105043:	83 c4 10             	add    $0x10,%esp
80105046:	85 c0                	test   %eax,%eax
80105048:	78 1e                	js     80105068 <sys_read+0x78>
  return fileread(f, p, n);
8010504a:	83 ec 04             	sub    $0x4,%esp
8010504d:	ff 75 f0             	push   -0x10(%ebp)
80105050:	ff 75 f4             	push   -0xc(%ebp)
80105053:	56                   	push   %esi
80105054:	e8 c7 bf ff ff       	call   80101020 <fileread>
80105059:	83 c4 10             	add    $0x10,%esp
}
8010505c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010505f:	5b                   	pop    %ebx
80105060:	5e                   	pop    %esi
80105061:	5d                   	pop    %ebp
80105062:	c3                   	ret    
80105063:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105067:	90                   	nop
    return -1;
80105068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010506d:	eb ed                	jmp    8010505c <sys_read+0x6c>
8010506f:	90                   	nop

80105070 <sys_write>:
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	56                   	push   %esi
80105074:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105075:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105078:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010507b:	53                   	push   %ebx
8010507c:	6a 00                	push   $0x0
8010507e:	e8 9d fb ff ff       	call   80104c20 <argint>
80105083:	83 c4 10             	add    $0x10,%esp
80105086:	85 c0                	test   %eax,%eax
80105088:	78 5e                	js     801050e8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010508a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010508e:	77 58                	ja     801050e8 <sys_write+0x78>
80105090:	e8 3b ea ff ff       	call   80103ad0 <myproc>
80105095:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105098:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010509c:	85 f6                	test   %esi,%esi
8010509e:	74 48                	je     801050e8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050a0:	83 ec 08             	sub    $0x8,%esp
801050a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050a6:	50                   	push   %eax
801050a7:	6a 02                	push   $0x2
801050a9:	e8 72 fb ff ff       	call   80104c20 <argint>
801050ae:	83 c4 10             	add    $0x10,%esp
801050b1:	85 c0                	test   %eax,%eax
801050b3:	78 33                	js     801050e8 <sys_write+0x78>
801050b5:	83 ec 04             	sub    $0x4,%esp
801050b8:	ff 75 f0             	push   -0x10(%ebp)
801050bb:	53                   	push   %ebx
801050bc:	6a 01                	push   $0x1
801050be:	e8 ad fb ff ff       	call   80104c70 <argptr>
801050c3:	83 c4 10             	add    $0x10,%esp
801050c6:	85 c0                	test   %eax,%eax
801050c8:	78 1e                	js     801050e8 <sys_write+0x78>
  return filewrite(f, p, n);
801050ca:	83 ec 04             	sub    $0x4,%esp
801050cd:	ff 75 f0             	push   -0x10(%ebp)
801050d0:	ff 75 f4             	push   -0xc(%ebp)
801050d3:	56                   	push   %esi
801050d4:	e8 d7 bf ff ff       	call   801010b0 <filewrite>
801050d9:	83 c4 10             	add    $0x10,%esp
}
801050dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050df:	5b                   	pop    %ebx
801050e0:	5e                   	pop    %esi
801050e1:	5d                   	pop    %ebp
801050e2:	c3                   	ret    
801050e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050e7:	90                   	nop
    return -1;
801050e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ed:	eb ed                	jmp    801050dc <sys_write+0x6c>
801050ef:	90                   	nop

801050f0 <sys_close>:
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	56                   	push   %esi
801050f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801050f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050fb:	50                   	push   %eax
801050fc:	6a 00                	push   $0x0
801050fe:	e8 1d fb ff ff       	call   80104c20 <argint>
80105103:	83 c4 10             	add    $0x10,%esp
80105106:	85 c0                	test   %eax,%eax
80105108:	78 3e                	js     80105148 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010510a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010510e:	77 38                	ja     80105148 <sys_close+0x58>
80105110:	e8 bb e9 ff ff       	call   80103ad0 <myproc>
80105115:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105118:	8d 5a 08             	lea    0x8(%edx),%ebx
8010511b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010511f:	85 f6                	test   %esi,%esi
80105121:	74 25                	je     80105148 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105123:	e8 a8 e9 ff ff       	call   80103ad0 <myproc>
  fileclose(f);
80105128:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010512b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105132:	00 
  fileclose(f);
80105133:	56                   	push   %esi
80105134:	e8 b7 bd ff ff       	call   80100ef0 <fileclose>
  return 0;
80105139:	83 c4 10             	add    $0x10,%esp
8010513c:	31 c0                	xor    %eax,%eax
}
8010513e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105141:	5b                   	pop    %ebx
80105142:	5e                   	pop    %esi
80105143:	5d                   	pop    %ebp
80105144:	c3                   	ret    
80105145:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105148:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010514d:	eb ef                	jmp    8010513e <sys_close+0x4e>
8010514f:	90                   	nop

80105150 <sys_fstat>:
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	56                   	push   %esi
80105154:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105155:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105158:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010515b:	53                   	push   %ebx
8010515c:	6a 00                	push   $0x0
8010515e:	e8 bd fa ff ff       	call   80104c20 <argint>
80105163:	83 c4 10             	add    $0x10,%esp
80105166:	85 c0                	test   %eax,%eax
80105168:	78 46                	js     801051b0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010516a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010516e:	77 40                	ja     801051b0 <sys_fstat+0x60>
80105170:	e8 5b e9 ff ff       	call   80103ad0 <myproc>
80105175:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105178:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010517c:	85 f6                	test   %esi,%esi
8010517e:	74 30                	je     801051b0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105180:	83 ec 04             	sub    $0x4,%esp
80105183:	6a 14                	push   $0x14
80105185:	53                   	push   %ebx
80105186:	6a 01                	push   $0x1
80105188:	e8 e3 fa ff ff       	call   80104c70 <argptr>
8010518d:	83 c4 10             	add    $0x10,%esp
80105190:	85 c0                	test   %eax,%eax
80105192:	78 1c                	js     801051b0 <sys_fstat+0x60>
  return filestat(f, st);
80105194:	83 ec 08             	sub    $0x8,%esp
80105197:	ff 75 f4             	push   -0xc(%ebp)
8010519a:	56                   	push   %esi
8010519b:	e8 30 be ff ff       	call   80100fd0 <filestat>
801051a0:	83 c4 10             	add    $0x10,%esp
}
801051a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051a6:	5b                   	pop    %ebx
801051a7:	5e                   	pop    %esi
801051a8:	5d                   	pop    %ebp
801051a9:	c3                   	ret    
801051aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801051b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051b5:	eb ec                	jmp    801051a3 <sys_fstat+0x53>
801051b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051be:	66 90                	xchg   %ax,%ax

801051c0 <sys_link>:
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	57                   	push   %edi
801051c4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051c5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801051c8:	53                   	push   %ebx
801051c9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051cc:	50                   	push   %eax
801051cd:	6a 00                	push   $0x0
801051cf:	e8 0c fb ff ff       	call   80104ce0 <argstr>
801051d4:	83 c4 10             	add    $0x10,%esp
801051d7:	85 c0                	test   %eax,%eax
801051d9:	0f 88 fb 00 00 00    	js     801052da <sys_link+0x11a>
801051df:	83 ec 08             	sub    $0x8,%esp
801051e2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801051e5:	50                   	push   %eax
801051e6:	6a 01                	push   $0x1
801051e8:	e8 f3 fa ff ff       	call   80104ce0 <argstr>
801051ed:	83 c4 10             	add    $0x10,%esp
801051f0:	85 c0                	test   %eax,%eax
801051f2:	0f 88 e2 00 00 00    	js     801052da <sys_link+0x11a>
  begin_op();
801051f8:	e8 c3 dc ff ff       	call   80102ec0 <begin_op>
  if((ip = namei(old)) == 0){
801051fd:	83 ec 0c             	sub    $0xc,%esp
80105200:	ff 75 d4             	push   -0x2c(%ebp)
80105203:	e8 98 ce ff ff       	call   801020a0 <namei>
80105208:	83 c4 10             	add    $0x10,%esp
8010520b:	89 c3                	mov    %eax,%ebx
8010520d:	85 c0                	test   %eax,%eax
8010520f:	0f 84 e4 00 00 00    	je     801052f9 <sys_link+0x139>
  ilock(ip);
80105215:	83 ec 0c             	sub    $0xc,%esp
80105218:	50                   	push   %eax
80105219:	e8 62 c5 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
8010521e:	83 c4 10             	add    $0x10,%esp
80105221:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105226:	0f 84 b5 00 00 00    	je     801052e1 <sys_link+0x121>
  iupdate(ip);
8010522c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010522f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105234:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105237:	53                   	push   %ebx
80105238:	e8 93 c4 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010523d:	89 1c 24             	mov    %ebx,(%esp)
80105240:	e8 1b c6 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105245:	58                   	pop    %eax
80105246:	5a                   	pop    %edx
80105247:	57                   	push   %edi
80105248:	ff 75 d0             	push   -0x30(%ebp)
8010524b:	e8 70 ce ff ff       	call   801020c0 <nameiparent>
80105250:	83 c4 10             	add    $0x10,%esp
80105253:	89 c6                	mov    %eax,%esi
80105255:	85 c0                	test   %eax,%eax
80105257:	74 5b                	je     801052b4 <sys_link+0xf4>
  ilock(dp);
80105259:	83 ec 0c             	sub    $0xc,%esp
8010525c:	50                   	push   %eax
8010525d:	e8 1e c5 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105262:	8b 03                	mov    (%ebx),%eax
80105264:	83 c4 10             	add    $0x10,%esp
80105267:	39 06                	cmp    %eax,(%esi)
80105269:	75 3d                	jne    801052a8 <sys_link+0xe8>
8010526b:	83 ec 04             	sub    $0x4,%esp
8010526e:	ff 73 04             	push   0x4(%ebx)
80105271:	57                   	push   %edi
80105272:	56                   	push   %esi
80105273:	e8 68 cd ff ff       	call   80101fe0 <dirlink>
80105278:	83 c4 10             	add    $0x10,%esp
8010527b:	85 c0                	test   %eax,%eax
8010527d:	78 29                	js     801052a8 <sys_link+0xe8>
  iunlockput(dp);
8010527f:	83 ec 0c             	sub    $0xc,%esp
80105282:	56                   	push   %esi
80105283:	e8 88 c7 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105288:	89 1c 24             	mov    %ebx,(%esp)
8010528b:	e8 20 c6 ff ff       	call   801018b0 <iput>
  end_op();
80105290:	e8 9b dc ff ff       	call   80102f30 <end_op>
  return 0;
80105295:	83 c4 10             	add    $0x10,%esp
80105298:	31 c0                	xor    %eax,%eax
}
8010529a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010529d:	5b                   	pop    %ebx
8010529e:	5e                   	pop    %esi
8010529f:	5f                   	pop    %edi
801052a0:	5d                   	pop    %ebp
801052a1:	c3                   	ret    
801052a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801052a8:	83 ec 0c             	sub    $0xc,%esp
801052ab:	56                   	push   %esi
801052ac:	e8 5f c7 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801052b1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801052b4:	83 ec 0c             	sub    $0xc,%esp
801052b7:	53                   	push   %ebx
801052b8:	e8 c3 c4 ff ff       	call   80101780 <ilock>
  ip->nlink--;
801052bd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052c2:	89 1c 24             	mov    %ebx,(%esp)
801052c5:	e8 06 c4 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801052ca:	89 1c 24             	mov    %ebx,(%esp)
801052cd:	e8 3e c7 ff ff       	call   80101a10 <iunlockput>
  end_op();
801052d2:	e8 59 dc ff ff       	call   80102f30 <end_op>
  return -1;
801052d7:	83 c4 10             	add    $0x10,%esp
801052da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052df:	eb b9                	jmp    8010529a <sys_link+0xda>
    iunlockput(ip);
801052e1:	83 ec 0c             	sub    $0xc,%esp
801052e4:	53                   	push   %ebx
801052e5:	e8 26 c7 ff ff       	call   80101a10 <iunlockput>
    end_op();
801052ea:	e8 41 dc ff ff       	call   80102f30 <end_op>
    return -1;
801052ef:	83 c4 10             	add    $0x10,%esp
801052f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052f7:	eb a1                	jmp    8010529a <sys_link+0xda>
    end_op();
801052f9:	e8 32 dc ff ff       	call   80102f30 <end_op>
    return -1;
801052fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105303:	eb 95                	jmp    8010529a <sys_link+0xda>
80105305:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010530c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105310 <sys_unlink>:
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105315:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105318:	53                   	push   %ebx
80105319:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010531c:	50                   	push   %eax
8010531d:	6a 00                	push   $0x0
8010531f:	e8 bc f9 ff ff       	call   80104ce0 <argstr>
80105324:	83 c4 10             	add    $0x10,%esp
80105327:	85 c0                	test   %eax,%eax
80105329:	0f 88 7a 01 00 00    	js     801054a9 <sys_unlink+0x199>
  begin_op();
8010532f:	e8 8c db ff ff       	call   80102ec0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105334:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105337:	83 ec 08             	sub    $0x8,%esp
8010533a:	53                   	push   %ebx
8010533b:	ff 75 c0             	push   -0x40(%ebp)
8010533e:	e8 7d cd ff ff       	call   801020c0 <nameiparent>
80105343:	83 c4 10             	add    $0x10,%esp
80105346:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105349:	85 c0                	test   %eax,%eax
8010534b:	0f 84 62 01 00 00    	je     801054b3 <sys_unlink+0x1a3>
  ilock(dp);
80105351:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105354:	83 ec 0c             	sub    $0xc,%esp
80105357:	57                   	push   %edi
80105358:	e8 23 c4 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010535d:	58                   	pop    %eax
8010535e:	5a                   	pop    %edx
8010535f:	68 a4 80 10 80       	push   $0x801080a4
80105364:	53                   	push   %ebx
80105365:	e8 56 c9 ff ff       	call   80101cc0 <namecmp>
8010536a:	83 c4 10             	add    $0x10,%esp
8010536d:	85 c0                	test   %eax,%eax
8010536f:	0f 84 fb 00 00 00    	je     80105470 <sys_unlink+0x160>
80105375:	83 ec 08             	sub    $0x8,%esp
80105378:	68 a3 80 10 80       	push   $0x801080a3
8010537d:	53                   	push   %ebx
8010537e:	e8 3d c9 ff ff       	call   80101cc0 <namecmp>
80105383:	83 c4 10             	add    $0x10,%esp
80105386:	85 c0                	test   %eax,%eax
80105388:	0f 84 e2 00 00 00    	je     80105470 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010538e:	83 ec 04             	sub    $0x4,%esp
80105391:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105394:	50                   	push   %eax
80105395:	53                   	push   %ebx
80105396:	57                   	push   %edi
80105397:	e8 44 c9 ff ff       	call   80101ce0 <dirlookup>
8010539c:	83 c4 10             	add    $0x10,%esp
8010539f:	89 c3                	mov    %eax,%ebx
801053a1:	85 c0                	test   %eax,%eax
801053a3:	0f 84 c7 00 00 00    	je     80105470 <sys_unlink+0x160>
  ilock(ip);
801053a9:	83 ec 0c             	sub    $0xc,%esp
801053ac:	50                   	push   %eax
801053ad:	e8 ce c3 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
801053b2:	83 c4 10             	add    $0x10,%esp
801053b5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801053ba:	0f 8e 1c 01 00 00    	jle    801054dc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801053c0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053c5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801053c8:	74 66                	je     80105430 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801053ca:	83 ec 04             	sub    $0x4,%esp
801053cd:	6a 10                	push   $0x10
801053cf:	6a 00                	push   $0x0
801053d1:	57                   	push   %edi
801053d2:	e8 89 f5 ff ff       	call   80104960 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053d7:	6a 10                	push   $0x10
801053d9:	ff 75 c4             	push   -0x3c(%ebp)
801053dc:	57                   	push   %edi
801053dd:	ff 75 b4             	push   -0x4c(%ebp)
801053e0:	e8 ab c7 ff ff       	call   80101b90 <writei>
801053e5:	83 c4 20             	add    $0x20,%esp
801053e8:	83 f8 10             	cmp    $0x10,%eax
801053eb:	0f 85 de 00 00 00    	jne    801054cf <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801053f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053f6:	0f 84 94 00 00 00    	je     80105490 <sys_unlink+0x180>
  iunlockput(dp);
801053fc:	83 ec 0c             	sub    $0xc,%esp
801053ff:	ff 75 b4             	push   -0x4c(%ebp)
80105402:	e8 09 c6 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105407:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010540c:	89 1c 24             	mov    %ebx,(%esp)
8010540f:	e8 bc c2 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105414:	89 1c 24             	mov    %ebx,(%esp)
80105417:	e8 f4 c5 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010541c:	e8 0f db ff ff       	call   80102f30 <end_op>
  return 0;
80105421:	83 c4 10             	add    $0x10,%esp
80105424:	31 c0                	xor    %eax,%eax
}
80105426:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105429:	5b                   	pop    %ebx
8010542a:	5e                   	pop    %esi
8010542b:	5f                   	pop    %edi
8010542c:	5d                   	pop    %ebp
8010542d:	c3                   	ret    
8010542e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105430:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105434:	76 94                	jbe    801053ca <sys_unlink+0xba>
80105436:	be 20 00 00 00       	mov    $0x20,%esi
8010543b:	eb 0b                	jmp    80105448 <sys_unlink+0x138>
8010543d:	8d 76 00             	lea    0x0(%esi),%esi
80105440:	83 c6 10             	add    $0x10,%esi
80105443:	3b 73 58             	cmp    0x58(%ebx),%esi
80105446:	73 82                	jae    801053ca <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105448:	6a 10                	push   $0x10
8010544a:	56                   	push   %esi
8010544b:	57                   	push   %edi
8010544c:	53                   	push   %ebx
8010544d:	e8 3e c6 ff ff       	call   80101a90 <readi>
80105452:	83 c4 10             	add    $0x10,%esp
80105455:	83 f8 10             	cmp    $0x10,%eax
80105458:	75 68                	jne    801054c2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010545a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010545f:	74 df                	je     80105440 <sys_unlink+0x130>
    iunlockput(ip);
80105461:	83 ec 0c             	sub    $0xc,%esp
80105464:	53                   	push   %ebx
80105465:	e8 a6 c5 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010546a:	83 c4 10             	add    $0x10,%esp
8010546d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105470:	83 ec 0c             	sub    $0xc,%esp
80105473:	ff 75 b4             	push   -0x4c(%ebp)
80105476:	e8 95 c5 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010547b:	e8 b0 da ff ff       	call   80102f30 <end_op>
  return -1;
80105480:	83 c4 10             	add    $0x10,%esp
80105483:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105488:	eb 9c                	jmp    80105426 <sys_unlink+0x116>
8010548a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105490:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105493:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105496:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010549b:	50                   	push   %eax
8010549c:	e8 2f c2 ff ff       	call   801016d0 <iupdate>
801054a1:	83 c4 10             	add    $0x10,%esp
801054a4:	e9 53 ff ff ff       	jmp    801053fc <sys_unlink+0xec>
    return -1;
801054a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ae:	e9 73 ff ff ff       	jmp    80105426 <sys_unlink+0x116>
    end_op();
801054b3:	e8 78 da ff ff       	call   80102f30 <end_op>
    return -1;
801054b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054bd:	e9 64 ff ff ff       	jmp    80105426 <sys_unlink+0x116>
      panic("isdirempty: readi");
801054c2:	83 ec 0c             	sub    $0xc,%esp
801054c5:	68 c8 80 10 80       	push   $0x801080c8
801054ca:	e8 b1 ae ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801054cf:	83 ec 0c             	sub    $0xc,%esp
801054d2:	68 da 80 10 80       	push   $0x801080da
801054d7:	e8 a4 ae ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801054dc:	83 ec 0c             	sub    $0xc,%esp
801054df:	68 b6 80 10 80       	push   $0x801080b6
801054e4:	e8 97 ae ff ff       	call   80100380 <panic>
801054e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054f0 <sys_open>:

int
sys_open(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	57                   	push   %edi
801054f4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054f8:	53                   	push   %ebx
801054f9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054fc:	50                   	push   %eax
801054fd:	6a 00                	push   $0x0
801054ff:	e8 dc f7 ff ff       	call   80104ce0 <argstr>
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	85 c0                	test   %eax,%eax
80105509:	0f 88 8e 00 00 00    	js     8010559d <sys_open+0xad>
8010550f:	83 ec 08             	sub    $0x8,%esp
80105512:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105515:	50                   	push   %eax
80105516:	6a 01                	push   $0x1
80105518:	e8 03 f7 ff ff       	call   80104c20 <argint>
8010551d:	83 c4 10             	add    $0x10,%esp
80105520:	85 c0                	test   %eax,%eax
80105522:	78 79                	js     8010559d <sys_open+0xad>
    return -1;

  begin_op();
80105524:	e8 97 d9 ff ff       	call   80102ec0 <begin_op>

  if(omode & O_CREATE){
80105529:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010552d:	75 79                	jne    801055a8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010552f:	83 ec 0c             	sub    $0xc,%esp
80105532:	ff 75 e0             	push   -0x20(%ebp)
80105535:	e8 66 cb ff ff       	call   801020a0 <namei>
8010553a:	83 c4 10             	add    $0x10,%esp
8010553d:	89 c6                	mov    %eax,%esi
8010553f:	85 c0                	test   %eax,%eax
80105541:	0f 84 7e 00 00 00    	je     801055c5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105547:	83 ec 0c             	sub    $0xc,%esp
8010554a:	50                   	push   %eax
8010554b:	e8 30 c2 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105550:	83 c4 10             	add    $0x10,%esp
80105553:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105558:	0f 84 c2 00 00 00    	je     80105620 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010555e:	e8 cd b8 ff ff       	call   80100e30 <filealloc>
80105563:	89 c7                	mov    %eax,%edi
80105565:	85 c0                	test   %eax,%eax
80105567:	74 23                	je     8010558c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105569:	e8 62 e5 ff ff       	call   80103ad0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010556e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105570:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105574:	85 d2                	test   %edx,%edx
80105576:	74 60                	je     801055d8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105578:	83 c3 01             	add    $0x1,%ebx
8010557b:	83 fb 10             	cmp    $0x10,%ebx
8010557e:	75 f0                	jne    80105570 <sys_open+0x80>
    if(f)
      fileclose(f);
80105580:	83 ec 0c             	sub    $0xc,%esp
80105583:	57                   	push   %edi
80105584:	e8 67 b9 ff ff       	call   80100ef0 <fileclose>
80105589:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010558c:	83 ec 0c             	sub    $0xc,%esp
8010558f:	56                   	push   %esi
80105590:	e8 7b c4 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105595:	e8 96 d9 ff ff       	call   80102f30 <end_op>
    return -1;
8010559a:	83 c4 10             	add    $0x10,%esp
8010559d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055a2:	eb 6d                	jmp    80105611 <sys_open+0x121>
801055a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801055a8:	83 ec 0c             	sub    $0xc,%esp
801055ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055ae:	31 c9                	xor    %ecx,%ecx
801055b0:	ba 02 00 00 00       	mov    $0x2,%edx
801055b5:	6a 00                	push   $0x0
801055b7:	e8 14 f8 ff ff       	call   80104dd0 <create>
    if(ip == 0){
801055bc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801055bf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801055c1:	85 c0                	test   %eax,%eax
801055c3:	75 99                	jne    8010555e <sys_open+0x6e>
      end_op();
801055c5:	e8 66 d9 ff ff       	call   80102f30 <end_op>
      return -1;
801055ca:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055cf:	eb 40                	jmp    80105611 <sys_open+0x121>
801055d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801055d8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801055db:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801055df:	56                   	push   %esi
801055e0:	e8 7b c2 ff ff       	call   80101860 <iunlock>
  end_op();
801055e5:	e8 46 d9 ff ff       	call   80102f30 <end_op>

  f->type = FD_INODE;
801055ea:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801055f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055f3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801055f6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801055f9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801055fb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105602:	f7 d0                	not    %eax
80105604:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105607:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010560a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010560d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105611:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105614:	89 d8                	mov    %ebx,%eax
80105616:	5b                   	pop    %ebx
80105617:	5e                   	pop    %esi
80105618:	5f                   	pop    %edi
80105619:	5d                   	pop    %ebp
8010561a:	c3                   	ret    
8010561b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010561f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105620:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105623:	85 c9                	test   %ecx,%ecx
80105625:	0f 84 33 ff ff ff    	je     8010555e <sys_open+0x6e>
8010562b:	e9 5c ff ff ff       	jmp    8010558c <sys_open+0x9c>

80105630 <sys_mkdir>:

int
sys_mkdir(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105636:	e8 85 d8 ff ff       	call   80102ec0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010563b:	83 ec 08             	sub    $0x8,%esp
8010563e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105641:	50                   	push   %eax
80105642:	6a 00                	push   $0x0
80105644:	e8 97 f6 ff ff       	call   80104ce0 <argstr>
80105649:	83 c4 10             	add    $0x10,%esp
8010564c:	85 c0                	test   %eax,%eax
8010564e:	78 30                	js     80105680 <sys_mkdir+0x50>
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105656:	31 c9                	xor    %ecx,%ecx
80105658:	ba 01 00 00 00       	mov    $0x1,%edx
8010565d:	6a 00                	push   $0x0
8010565f:	e8 6c f7 ff ff       	call   80104dd0 <create>
80105664:	83 c4 10             	add    $0x10,%esp
80105667:	85 c0                	test   %eax,%eax
80105669:	74 15                	je     80105680 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010566b:	83 ec 0c             	sub    $0xc,%esp
8010566e:	50                   	push   %eax
8010566f:	e8 9c c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105674:	e8 b7 d8 ff ff       	call   80102f30 <end_op>
  return 0;
80105679:	83 c4 10             	add    $0x10,%esp
8010567c:	31 c0                	xor    %eax,%eax
}
8010567e:	c9                   	leave  
8010567f:	c3                   	ret    
    end_op();
80105680:	e8 ab d8 ff ff       	call   80102f30 <end_op>
    return -1;
80105685:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010568a:	c9                   	leave  
8010568b:	c3                   	ret    
8010568c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105690 <sys_mknod>:

int
sys_mknod(void)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105696:	e8 25 d8 ff ff       	call   80102ec0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010569b:	83 ec 08             	sub    $0x8,%esp
8010569e:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056a1:	50                   	push   %eax
801056a2:	6a 00                	push   $0x0
801056a4:	e8 37 f6 ff ff       	call   80104ce0 <argstr>
801056a9:	83 c4 10             	add    $0x10,%esp
801056ac:	85 c0                	test   %eax,%eax
801056ae:	78 60                	js     80105710 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801056b0:	83 ec 08             	sub    $0x8,%esp
801056b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056b6:	50                   	push   %eax
801056b7:	6a 01                	push   $0x1
801056b9:	e8 62 f5 ff ff       	call   80104c20 <argint>
  if((argstr(0, &path)) < 0 ||
801056be:	83 c4 10             	add    $0x10,%esp
801056c1:	85 c0                	test   %eax,%eax
801056c3:	78 4b                	js     80105710 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801056c5:	83 ec 08             	sub    $0x8,%esp
801056c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056cb:	50                   	push   %eax
801056cc:	6a 02                	push   $0x2
801056ce:	e8 4d f5 ff ff       	call   80104c20 <argint>
     argint(1, &major) < 0 ||
801056d3:	83 c4 10             	add    $0x10,%esp
801056d6:	85 c0                	test   %eax,%eax
801056d8:	78 36                	js     80105710 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801056da:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801056de:	83 ec 0c             	sub    $0xc,%esp
801056e1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801056e5:	ba 03 00 00 00       	mov    $0x3,%edx
801056ea:	50                   	push   %eax
801056eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801056ee:	e8 dd f6 ff ff       	call   80104dd0 <create>
     argint(2, &minor) < 0 ||
801056f3:	83 c4 10             	add    $0x10,%esp
801056f6:	85 c0                	test   %eax,%eax
801056f8:	74 16                	je     80105710 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056fa:	83 ec 0c             	sub    $0xc,%esp
801056fd:	50                   	push   %eax
801056fe:	e8 0d c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105703:	e8 28 d8 ff ff       	call   80102f30 <end_op>
  return 0;
80105708:	83 c4 10             	add    $0x10,%esp
8010570b:	31 c0                	xor    %eax,%eax
}
8010570d:	c9                   	leave  
8010570e:	c3                   	ret    
8010570f:	90                   	nop
    end_op();
80105710:	e8 1b d8 ff ff       	call   80102f30 <end_op>
    return -1;
80105715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010571a:	c9                   	leave  
8010571b:	c3                   	ret    
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105720 <sys_chdir>:

int
sys_chdir(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	56                   	push   %esi
80105724:	53                   	push   %ebx
80105725:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105728:	e8 a3 e3 ff ff       	call   80103ad0 <myproc>
8010572d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010572f:	e8 8c d7 ff ff       	call   80102ec0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105734:	83 ec 08             	sub    $0x8,%esp
80105737:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010573a:	50                   	push   %eax
8010573b:	6a 00                	push   $0x0
8010573d:	e8 9e f5 ff ff       	call   80104ce0 <argstr>
80105742:	83 c4 10             	add    $0x10,%esp
80105745:	85 c0                	test   %eax,%eax
80105747:	78 77                	js     801057c0 <sys_chdir+0xa0>
80105749:	83 ec 0c             	sub    $0xc,%esp
8010574c:	ff 75 f4             	push   -0xc(%ebp)
8010574f:	e8 4c c9 ff ff       	call   801020a0 <namei>
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	89 c3                	mov    %eax,%ebx
80105759:	85 c0                	test   %eax,%eax
8010575b:	74 63                	je     801057c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010575d:	83 ec 0c             	sub    $0xc,%esp
80105760:	50                   	push   %eax
80105761:	e8 1a c0 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105766:	83 c4 10             	add    $0x10,%esp
80105769:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010576e:	75 30                	jne    801057a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105770:	83 ec 0c             	sub    $0xc,%esp
80105773:	53                   	push   %ebx
80105774:	e8 e7 c0 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105779:	58                   	pop    %eax
8010577a:	ff 76 68             	push   0x68(%esi)
8010577d:	e8 2e c1 ff ff       	call   801018b0 <iput>
  end_op();
80105782:	e8 a9 d7 ff ff       	call   80102f30 <end_op>
  curproc->cwd = ip;
80105787:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010578a:	83 c4 10             	add    $0x10,%esp
8010578d:	31 c0                	xor    %eax,%eax
}
8010578f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105792:	5b                   	pop    %ebx
80105793:	5e                   	pop    %esi
80105794:	5d                   	pop    %ebp
80105795:	c3                   	ret    
80105796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801057a0:	83 ec 0c             	sub    $0xc,%esp
801057a3:	53                   	push   %ebx
801057a4:	e8 67 c2 ff ff       	call   80101a10 <iunlockput>
    end_op();
801057a9:	e8 82 d7 ff ff       	call   80102f30 <end_op>
    return -1;
801057ae:	83 c4 10             	add    $0x10,%esp
801057b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b6:	eb d7                	jmp    8010578f <sys_chdir+0x6f>
801057b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057bf:	90                   	nop
    end_op();
801057c0:	e8 6b d7 ff ff       	call   80102f30 <end_op>
    return -1;
801057c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ca:	eb c3                	jmp    8010578f <sys_chdir+0x6f>
801057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057d0 <sys_exec>:

int
sys_exec(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	57                   	push   %edi
801057d4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057d5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801057db:	53                   	push   %ebx
801057dc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057e2:	50                   	push   %eax
801057e3:	6a 00                	push   $0x0
801057e5:	e8 f6 f4 ff ff       	call   80104ce0 <argstr>
801057ea:	83 c4 10             	add    $0x10,%esp
801057ed:	85 c0                	test   %eax,%eax
801057ef:	0f 88 87 00 00 00    	js     8010587c <sys_exec+0xac>
801057f5:	83 ec 08             	sub    $0x8,%esp
801057f8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057fe:	50                   	push   %eax
801057ff:	6a 01                	push   $0x1
80105801:	e8 1a f4 ff ff       	call   80104c20 <argint>
80105806:	83 c4 10             	add    $0x10,%esp
80105809:	85 c0                	test   %eax,%eax
8010580b:	78 6f                	js     8010587c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010580d:	83 ec 04             	sub    $0x4,%esp
80105810:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105816:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105818:	68 80 00 00 00       	push   $0x80
8010581d:	6a 00                	push   $0x0
8010581f:	56                   	push   %esi
80105820:	e8 3b f1 ff ff       	call   80104960 <memset>
80105825:	83 c4 10             	add    $0x10,%esp
80105828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105830:	83 ec 08             	sub    $0x8,%esp
80105833:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105839:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105840:	50                   	push   %eax
80105841:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105847:	01 f8                	add    %edi,%eax
80105849:	50                   	push   %eax
8010584a:	e8 41 f3 ff ff       	call   80104b90 <fetchint>
8010584f:	83 c4 10             	add    $0x10,%esp
80105852:	85 c0                	test   %eax,%eax
80105854:	78 26                	js     8010587c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105856:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010585c:	85 c0                	test   %eax,%eax
8010585e:	74 30                	je     80105890 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105860:	83 ec 08             	sub    $0x8,%esp
80105863:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105866:	52                   	push   %edx
80105867:	50                   	push   %eax
80105868:	e8 63 f3 ff ff       	call   80104bd0 <fetchstr>
8010586d:	83 c4 10             	add    $0x10,%esp
80105870:	85 c0                	test   %eax,%eax
80105872:	78 08                	js     8010587c <sys_exec+0xac>
  for(i=0;; i++){
80105874:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105877:	83 fb 20             	cmp    $0x20,%ebx
8010587a:	75 b4                	jne    80105830 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010587c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010587f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105884:	5b                   	pop    %ebx
80105885:	5e                   	pop    %esi
80105886:	5f                   	pop    %edi
80105887:	5d                   	pop    %ebp
80105888:	c3                   	ret    
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105890:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105897:	00 00 00 00 
  return exec(path, argv);
8010589b:	83 ec 08             	sub    $0x8,%esp
8010589e:	56                   	push   %esi
8010589f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801058a5:	e8 06 b2 ff ff       	call   80100ab0 <exec>
801058aa:	83 c4 10             	add    $0x10,%esp
}
801058ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058b0:	5b                   	pop    %ebx
801058b1:	5e                   	pop    %esi
801058b2:	5f                   	pop    %edi
801058b3:	5d                   	pop    %ebp
801058b4:	c3                   	ret    
801058b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058c0 <sys_pipe>:

int
sys_pipe(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	57                   	push   %edi
801058c4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058c5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801058c8:	53                   	push   %ebx
801058c9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058cc:	6a 08                	push   $0x8
801058ce:	50                   	push   %eax
801058cf:	6a 00                	push   $0x0
801058d1:	e8 9a f3 ff ff       	call   80104c70 <argptr>
801058d6:	83 c4 10             	add    $0x10,%esp
801058d9:	85 c0                	test   %eax,%eax
801058db:	78 4a                	js     80105927 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801058dd:	83 ec 08             	sub    $0x8,%esp
801058e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058e3:	50                   	push   %eax
801058e4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058e7:	50                   	push   %eax
801058e8:	e8 a3 dc ff ff       	call   80103590 <pipealloc>
801058ed:	83 c4 10             	add    $0x10,%esp
801058f0:	85 c0                	test   %eax,%eax
801058f2:	78 33                	js     80105927 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058f7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058f9:	e8 d2 e1 ff ff       	call   80103ad0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058fe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105900:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105904:	85 f6                	test   %esi,%esi
80105906:	74 28                	je     80105930 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105908:	83 c3 01             	add    $0x1,%ebx
8010590b:	83 fb 10             	cmp    $0x10,%ebx
8010590e:	75 f0                	jne    80105900 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105910:	83 ec 0c             	sub    $0xc,%esp
80105913:	ff 75 e0             	push   -0x20(%ebp)
80105916:	e8 d5 b5 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010591b:	58                   	pop    %eax
8010591c:	ff 75 e4             	push   -0x1c(%ebp)
8010591f:	e8 cc b5 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105924:	83 c4 10             	add    $0x10,%esp
80105927:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010592c:	eb 53                	jmp    80105981 <sys_pipe+0xc1>
8010592e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105930:	8d 73 08             	lea    0x8(%ebx),%esi
80105933:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105937:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010593a:	e8 91 e1 ff ff       	call   80103ad0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010593f:	31 d2                	xor    %edx,%edx
80105941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105948:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010594c:	85 c9                	test   %ecx,%ecx
8010594e:	74 20                	je     80105970 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105950:	83 c2 01             	add    $0x1,%edx
80105953:	83 fa 10             	cmp    $0x10,%edx
80105956:	75 f0                	jne    80105948 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105958:	e8 73 e1 ff ff       	call   80103ad0 <myproc>
8010595d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105964:	00 
80105965:	eb a9                	jmp    80105910 <sys_pipe+0x50>
80105967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105970:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105974:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105977:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105979:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010597c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010597f:	31 c0                	xor    %eax,%eax
}
80105981:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105984:	5b                   	pop    %ebx
80105985:	5e                   	pop    %esi
80105986:	5f                   	pop    %edi
80105987:	5d                   	pop    %ebp
80105988:	c3                   	ret    
80105989:	66 90                	xchg   %ax,%ax
8010598b:	66 90                	xchg   %ax,%ax
8010598d:	66 90                	xchg   %ax,%ax
8010598f:	90                   	nop

80105990 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105990:	e9 db e2 ff ff       	jmp    80103c70 <fork>
80105995:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059a0 <sys_forkcow>:
}

int
sys_forkcow(void)
{
  return forkcow();
801059a0:	e9 eb e3 ff ff       	jmp    80103d90 <forkcow>
801059a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059b0 <sys_exit>:
}

int
sys_exit(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	83 ec 08             	sub    $0x8,%esp
  exit();
801059b6:	e8 d5 e6 ff ff       	call   80104090 <exit>
  return 0;  // not reached
}
801059bb:	31 c0                	xor    %eax,%eax
801059bd:	c9                   	leave  
801059be:	c3                   	ret    
801059bf:	90                   	nop

801059c0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801059c0:	e9 fb e7 ff ff       	jmp    801041c0 <wait>
801059c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059d0 <sys_kill>:
}

int
sys_kill(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801059d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059d9:	50                   	push   %eax
801059da:	6a 00                	push   $0x0
801059dc:	e8 3f f2 ff ff       	call   80104c20 <argint>
801059e1:	83 c4 10             	add    $0x10,%esp
801059e4:	85 c0                	test   %eax,%eax
801059e6:	78 18                	js     80105a00 <sys_kill+0x30>
    return -1;
  return kill(pid);
801059e8:	83 ec 0c             	sub    $0xc,%esp
801059eb:	ff 75 f4             	push   -0xc(%ebp)
801059ee:	e8 6d ea ff ff       	call   80104460 <kill>
801059f3:	83 c4 10             	add    $0x10,%esp
}
801059f6:	c9                   	leave  
801059f7:	c3                   	ret    
801059f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ff:	90                   	nop
80105a00:	c9                   	leave  
    return -1;
80105a01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a06:	c3                   	ret    
80105a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0e:	66 90                	xchg   %ax,%ax

80105a10 <sys_getpid>:

int
sys_getpid(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a16:	e8 b5 e0 ff ff       	call   80103ad0 <myproc>
80105a1b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a1e:	c9                   	leave  
80105a1f:	c3                   	ret    

80105a20 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a24:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a27:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a2a:	50                   	push   %eax
80105a2b:	6a 00                	push   $0x0
80105a2d:	e8 ee f1 ff ff       	call   80104c20 <argint>
80105a32:	83 c4 10             	add    $0x10,%esp
80105a35:	85 c0                	test   %eax,%eax
80105a37:	78 27                	js     80105a60 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a39:	e8 92 e0 ff ff       	call   80103ad0 <myproc>
  if(growproc(n) < 0)
80105a3e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a41:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a43:	ff 75 f4             	push   -0xc(%ebp)
80105a46:	e8 a5 e1 ff ff       	call   80103bf0 <growproc>
80105a4b:	83 c4 10             	add    $0x10,%esp
80105a4e:	85 c0                	test   %eax,%eax
80105a50:	78 0e                	js     80105a60 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a52:	89 d8                	mov    %ebx,%eax
80105a54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a57:	c9                   	leave  
80105a58:	c3                   	ret    
80105a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a60:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a65:	eb eb                	jmp    80105a52 <sys_sbrk+0x32>
80105a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6e:	66 90                	xchg   %ax,%ax

80105a70 <sys_sleep>:

int
sys_sleep(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a74:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a77:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a7a:	50                   	push   %eax
80105a7b:	6a 00                	push   $0x0
80105a7d:	e8 9e f1 ff ff       	call   80104c20 <argint>
80105a82:	83 c4 10             	add    $0x10,%esp
80105a85:	85 c0                	test   %eax,%eax
80105a87:	0f 88 8a 00 00 00    	js     80105b17 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a8d:	83 ec 0c             	sub    $0xc,%esp
80105a90:	68 80 cc 14 80       	push   $0x8014cc80
80105a95:	e8 06 ee ff ff       	call   801048a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105a9d:	8b 1d 60 cc 14 80    	mov    0x8014cc60,%ebx
  while(ticks - ticks0 < n){
80105aa3:	83 c4 10             	add    $0x10,%esp
80105aa6:	85 d2                	test   %edx,%edx
80105aa8:	75 27                	jne    80105ad1 <sys_sleep+0x61>
80105aaa:	eb 54                	jmp    80105b00 <sys_sleep+0x90>
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ab0:	83 ec 08             	sub    $0x8,%esp
80105ab3:	68 80 cc 14 80       	push   $0x8014cc80
80105ab8:	68 60 cc 14 80       	push   $0x8014cc60
80105abd:	e8 7e e8 ff ff       	call   80104340 <sleep>
  while(ticks - ticks0 < n){
80105ac2:	a1 60 cc 14 80       	mov    0x8014cc60,%eax
80105ac7:	83 c4 10             	add    $0x10,%esp
80105aca:	29 d8                	sub    %ebx,%eax
80105acc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105acf:	73 2f                	jae    80105b00 <sys_sleep+0x90>
    if(myproc()->killed){
80105ad1:	e8 fa df ff ff       	call   80103ad0 <myproc>
80105ad6:	8b 40 24             	mov    0x24(%eax),%eax
80105ad9:	85 c0                	test   %eax,%eax
80105adb:	74 d3                	je     80105ab0 <sys_sleep+0x40>
      release(&tickslock);
80105add:	83 ec 0c             	sub    $0xc,%esp
80105ae0:	68 80 cc 14 80       	push   $0x8014cc80
80105ae5:	e8 56 ed ff ff       	call   80104840 <release>
  }
  release(&tickslock);
  return 0;
}
80105aea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105aed:	83 c4 10             	add    $0x10,%esp
80105af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105af5:	c9                   	leave  
80105af6:	c3                   	ret    
80105af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105afe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	68 80 cc 14 80       	push   $0x8014cc80
80105b08:	e8 33 ed ff ff       	call   80104840 <release>
  return 0;
80105b0d:	83 c4 10             	add    $0x10,%esp
80105b10:	31 c0                	xor    %eax,%eax
}
80105b12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b15:	c9                   	leave  
80105b16:	c3                   	ret    
    return -1;
80105b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b1c:	eb f4                	jmp    80105b12 <sys_sleep+0xa2>
80105b1e:	66 90                	xchg   %ax,%ax

80105b20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	53                   	push   %ebx
80105b24:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b27:	68 80 cc 14 80       	push   $0x8014cc80
80105b2c:	e8 6f ed ff ff       	call   801048a0 <acquire>
  xticks = ticks;
80105b31:	8b 1d 60 cc 14 80    	mov    0x8014cc60,%ebx
  release(&tickslock);
80105b37:	c7 04 24 80 cc 14 80 	movl   $0x8014cc80,(%esp)
80105b3e:	e8 fd ec ff ff       	call   80104840 <release>
  return xticks;
}
80105b43:	89 d8                	mov    %ebx,%eax
80105b45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b48:	c9                   	leave  
80105b49:	c3                   	ret    
80105b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b50 <sys_date>:

int
sys_date(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	83 ec 1c             	sub    $0x1c,%esp
  char *ptr;
  argptr(0, &ptr, sizeof(struct rtcdate*));
80105b56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b59:	6a 04                	push   $0x4
80105b5b:	50                   	push   %eax
80105b5c:	6a 00                	push   $0x0
80105b5e:	e8 0d f1 ff ff       	call   80104c70 <argptr>
  // seu código aqui

  struct rtcdate* r = (struct rtcdate*)ptr;

  cmostime(r);
80105b63:	58                   	pop    %eax
80105b64:	ff 75 f4             	push   -0xc(%ebp)
80105b67:	e8 c4 cf ff ff       	call   80102b30 <cmostime>

  return 0;
}
80105b6c:	31 c0                	xor    %eax,%eax
80105b6e:	c9                   	leave  
80105b6f:	c3                   	ret    

80105b70 <sys_virt2real>:



int
sys_virt2real(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	83 ec 1c             	sub    $0x1c,%esp

  char *ptr;
  argptr(0, &ptr, sizeof(char*));
80105b76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b79:	6a 04                	push   $0x4
80105b7b:	50                   	push   %eax
80105b7c:	6a 00                	push   $0x0
80105b7e:	e8 ed f0 ff ff       	call   80104c70 <argptr>

  pde_t *pgdir = myproc()->pgdir;
80105b83:	e8 48 df ff ff       	call   80103ad0 <myproc>
  pte_t *pte = walkpgdir(pgdir, ptr, 0);
80105b88:	83 c4 0c             	add    $0xc,%esp
80105b8b:	6a 00                	push   $0x0
80105b8d:	ff 75 f4             	push   -0xc(%ebp)
80105b90:	ff 70 04             	push   0x4(%eax)
80105b93:	e8 38 13 00 00       	call   80106ed0 <walkpgdir>

  if (pte == 0 || !(*pte & PTE_P)) {
80105b98:	83 c4 10             	add    $0x10,%esp
80105b9b:	85 c0                	test   %eax,%eax
80105b9d:	74 21                	je     80105bc0 <sys_virt2real+0x50>
80105b9f:	8b 10                	mov    (%eax),%edx
    return 0;
80105ba1:	31 c0                	xor    %eax,%eax
  if (pte == 0 || !(*pte & PTE_P)) {
80105ba3:	f6 c2 01             	test   $0x1,%dl
80105ba6:	74 10                	je     80105bb8 <sys_virt2real+0x48>
  }

  return (int)PTE_ADDR(*pte) + ((uint)ptr & 0xFFF);
80105ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bab:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80105bb1:	25 ff 0f 00 00       	and    $0xfff,%eax
80105bb6:	09 d0                	or     %edx,%eax
}
80105bb8:	c9                   	leave  
80105bb9:	c3                   	ret    
80105bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105bc0:	c9                   	leave  
    return 0;
80105bc1:	31 c0                	xor    %eax,%eax
}
80105bc3:	c3                   	ret    
80105bc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bcf:	90                   	nop

80105bd0 <sys_num_pages>:

int
sys_num_pages(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	57                   	push   %edi
80105bd4:	56                   	push   %esi
80105bd5:	53                   	push   %ebx
80105bd6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p = myproc(); 
80105bd9:	e8 f2 de ff ff       	call   80103ad0 <myproc>
    if (!p) {
80105bde:	85 c0                	test   %eax,%eax
80105be0:	74 51                	je     80105c33 <sys_num_pages+0x63>
    }

    pde_t *pgdir = p->pgdir; 
    int count = 0;

    for (int i = 0; i < NPDENTRIES; i++) {
80105be2:	8b 70 04             	mov    0x4(%eax),%esi
    int count = 0;
80105be5:	31 c9                	xor    %ecx,%ecx
80105be7:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80105bed:	eb 08                	jmp    80105bf7 <sys_num_pages+0x27>
80105bef:	90                   	nop
    for (int i = 0; i < NPDENTRIES; i++) {
80105bf0:	83 c6 04             	add    $0x4,%esi
80105bf3:	39 fe                	cmp    %edi,%esi
80105bf5:	74 32                	je     80105c29 <sys_num_pages+0x59>
        if (pgdir[i] & PTE_P) { 
80105bf7:	8b 1e                	mov    (%esi),%ebx
80105bf9:	f6 c3 01             	test   $0x1,%bl
80105bfc:	74 f2                	je     80105bf0 <sys_num_pages+0x20>
            pte_t *pte = (pte_t *)P2V(PTE_ADDR(pgdir[i])); 
80105bfe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105c04:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
            for (int j = 0; j < NPTENTRIES; j++) {
80105c0a:	81 eb 00 f0 ff 7f    	sub    $0x7ffff000,%ebx
                if (pte[j] & PTE_P) { 
80105c10:	8b 10                	mov    (%eax),%edx
80105c12:	83 e2 01             	and    $0x1,%edx
                    count++; 
80105c15:	83 fa 01             	cmp    $0x1,%edx
80105c18:	83 d9 ff             	sbb    $0xffffffff,%ecx
            for (int j = 0; j < NPTENTRIES; j++) {
80105c1b:	83 c0 04             	add    $0x4,%eax
80105c1e:	39 c3                	cmp    %eax,%ebx
80105c20:	75 ee                	jne    80105c10 <sys_num_pages+0x40>
    for (int i = 0; i < NPDENTRIES; i++) {
80105c22:	83 c6 04             	add    $0x4,%esi
80105c25:	39 fe                	cmp    %edi,%esi
80105c27:	75 ce                	jne    80105bf7 <sys_num_pages+0x27>
            }
        }
    }

    return count;
80105c29:	83 c4 0c             	add    $0xc,%esp
80105c2c:	89 c8                	mov    %ecx,%eax
80105c2e:	5b                   	pop    %ebx
80105c2f:	5e                   	pop    %esi
80105c30:	5f                   	pop    %edi
80105c31:	5d                   	pop    %ebp
80105c32:	c3                   	ret    
80105c33:	83 c4 0c             	add    $0xc,%esp
        return 0; 
80105c36:	31 c9                	xor    %ecx,%ecx
80105c38:	5b                   	pop    %ebx
80105c39:	89 c8                	mov    %ecx,%eax
80105c3b:	5e                   	pop    %esi
80105c3c:	5f                   	pop    %edi
80105c3d:	5d                   	pop    %ebp
80105c3e:	c3                   	ret    

80105c3f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105c3f:	1e                   	push   %ds
  pushl %es
80105c40:	06                   	push   %es
  pushl %fs
80105c41:	0f a0                	push   %fs
  pushl %gs
80105c43:	0f a8                	push   %gs
  pushal
80105c45:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105c46:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105c4a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105c4c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105c4e:	54                   	push   %esp
  call trap
80105c4f:	e8 cc 00 00 00       	call   80105d20 <trap>
  addl $4, %esp
80105c54:	83 c4 04             	add    $0x4,%esp

80105c57 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105c57:	61                   	popa   
  popl %gs
80105c58:	0f a9                	pop    %gs
  popl %fs
80105c5a:	0f a1                	pop    %fs
  popl %es
80105c5c:	07                   	pop    %es
  popl %ds
80105c5d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105c5e:	83 c4 08             	add    $0x8,%esp
  iret
80105c61:	cf                   	iret   
80105c62:	66 90                	xchg   %ax,%ax
80105c64:	66 90                	xchg   %ax,%ax
80105c66:	66 90                	xchg   %ax,%ax
80105c68:	66 90                	xchg   %ax,%ax
80105c6a:	66 90                	xchg   %ax,%ax
80105c6c:	66 90                	xchg   %ax,%ax
80105c6e:	66 90                	xchg   %ax,%ax

80105c70 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c70:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c71:	31 c0                	xor    %eax,%eax
{
80105c73:	89 e5                	mov    %esp,%ebp
80105c75:	83 ec 08             	sub    $0x8,%esp
80105c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c80:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105c87:	c7 04 c5 c2 cc 14 80 	movl   $0x8e000008,-0x7feb333e(,%eax,8)
80105c8e:	08 00 00 8e 
80105c92:	66 89 14 c5 c0 cc 14 	mov    %dx,-0x7feb3340(,%eax,8)
80105c99:	80 
80105c9a:	c1 ea 10             	shr    $0x10,%edx
80105c9d:	66 89 14 c5 c6 cc 14 	mov    %dx,-0x7feb333a(,%eax,8)
80105ca4:	80 
  for(i = 0; i < 256; i++)
80105ca5:	83 c0 01             	add    $0x1,%eax
80105ca8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105cad:	75 d1                	jne    80105c80 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105caf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cb2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105cb7:	c7 05 c2 ce 14 80 08 	movl   $0xef000008,0x8014cec2
80105cbe:	00 00 ef 
  initlock(&tickslock, "time");
80105cc1:	68 e9 80 10 80       	push   $0x801080e9
80105cc6:	68 80 cc 14 80       	push   $0x8014cc80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ccb:	66 a3 c0 ce 14 80    	mov    %ax,0x8014cec0
80105cd1:	c1 e8 10             	shr    $0x10,%eax
80105cd4:	66 a3 c6 ce 14 80    	mov    %ax,0x8014cec6
  initlock(&tickslock, "time");
80105cda:	e8 f1 e9 ff ff       	call   801046d0 <initlock>
}
80105cdf:	83 c4 10             	add    $0x10,%esp
80105ce2:	c9                   	leave  
80105ce3:	c3                   	ret    
80105ce4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cef:	90                   	nop

80105cf0 <idtinit>:

void
idtinit(void)
{
80105cf0:	55                   	push   %ebp
  pd[0] = size-1;
80105cf1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105cf6:	89 e5                	mov    %esp,%ebp
80105cf8:	83 ec 10             	sub    $0x10,%esp
80105cfb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105cff:	b8 c0 cc 14 80       	mov    $0x8014ccc0,%eax
80105d04:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105d08:	c1 e8 10             	shr    $0x10,%eax
80105d0b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105d0f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d12:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d15:	c9                   	leave  
80105d16:	c3                   	ret    
80105d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d1e:	66 90                	xchg   %ax,%ax

80105d20 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	57                   	push   %edi
80105d24:	56                   	push   %esi
80105d25:	53                   	push   %ebx
80105d26:	83 ec 1c             	sub    $0x1c,%esp
80105d29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105d2c:	8b 43 30             	mov    0x30(%ebx),%eax
80105d2f:	83 f8 40             	cmp    $0x40,%eax
80105d32:	0f 84 38 01 00 00    	je     80105e70 <trap+0x150>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d38:	83 e8 0e             	sub    $0xe,%eax
80105d3b:	83 f8 31             	cmp    $0x31,%eax
80105d3e:	0f 87 8c 00 00 00    	ja     80105dd0 <trap+0xb0>
80105d44:	ff 24 85 d8 81 10 80 	jmp    *-0x7fef7e28(,%eax,4)
80105d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d4f:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105d50:	e8 5b dd ff ff       	call   80103ab0 <cpuid>
80105d55:	85 c0                	test   %eax,%eax
80105d57:	0f 84 73 02 00 00    	je     80105fd0 <trap+0x2b0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105d5d:	e8 0e cd ff ff       	call   80102a70 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d62:	e8 69 dd ff ff       	call   80103ad0 <myproc>
80105d67:	85 c0                	test   %eax,%eax
80105d69:	74 1d                	je     80105d88 <trap+0x68>
80105d6b:	e8 60 dd ff ff       	call   80103ad0 <myproc>
80105d70:	8b 50 24             	mov    0x24(%eax),%edx
80105d73:	85 d2                	test   %edx,%edx
80105d75:	74 11                	je     80105d88 <trap+0x68>
80105d77:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d7b:	83 e0 03             	and    $0x3,%eax
80105d7e:	66 83 f8 03          	cmp    $0x3,%ax
80105d82:	0f 84 28 02 00 00    	je     80105fb0 <trap+0x290>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d88:	e8 43 dd ff ff       	call   80103ad0 <myproc>
80105d8d:	85 c0                	test   %eax,%eax
80105d8f:	74 0f                	je     80105da0 <trap+0x80>
80105d91:	e8 3a dd ff ff       	call   80103ad0 <myproc>
80105d96:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d9a:	0f 84 b8 00 00 00    	je     80105e58 <trap+0x138>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105da0:	e8 2b dd ff ff       	call   80103ad0 <myproc>
80105da5:	85 c0                	test   %eax,%eax
80105da7:	74 1d                	je     80105dc6 <trap+0xa6>
80105da9:	e8 22 dd ff ff       	call   80103ad0 <myproc>
80105dae:	8b 40 24             	mov    0x24(%eax),%eax
80105db1:	85 c0                	test   %eax,%eax
80105db3:	74 11                	je     80105dc6 <trap+0xa6>
80105db5:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105db9:	83 e0 03             	and    $0x3,%eax
80105dbc:	66 83 f8 03          	cmp    $0x3,%ax
80105dc0:	0f 84 d7 00 00 00    	je     80105e9d <trap+0x17d>
    exit();
}
80105dc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dc9:	5b                   	pop    %ebx
80105dca:	5e                   	pop    %esi
80105dcb:	5f                   	pop    %edi
80105dcc:	5d                   	pop    %ebp
80105dcd:	c3                   	ret    
80105dce:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105dd0:	e8 fb dc ff ff       	call   80103ad0 <myproc>
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	0f 84 76 02 00 00    	je     80106053 <trap+0x333>
80105ddd:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105de1:	0f 84 6c 02 00 00    	je     80106053 <trap+0x333>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105de7:	0f 20 d1             	mov    %cr2,%ecx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dea:	8b 53 38             	mov    0x38(%ebx),%edx
80105ded:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105df0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105df3:	e8 b8 dc ff ff       	call   80103ab0 <cpuid>
80105df8:	8b 73 30             	mov    0x30(%ebx),%esi
80105dfb:	89 c7                	mov    %eax,%edi
80105dfd:	8b 43 34             	mov    0x34(%ebx),%eax
80105e00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105e03:	e8 c8 dc ff ff       	call   80103ad0 <myproc>
80105e08:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105e0b:	e8 c0 dc ff ff       	call   80103ad0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e10:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105e13:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e16:	51                   	push   %ecx
80105e17:	52                   	push   %edx
80105e18:	57                   	push   %edi
80105e19:	ff 75 e4             	push   -0x1c(%ebp)
80105e1c:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105e1d:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105e20:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e23:	56                   	push   %esi
80105e24:	ff 70 10             	push   0x10(%eax)
80105e27:	68 94 81 10 80       	push   $0x80108194
80105e2c:	e8 6f a8 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105e31:	83 c4 20             	add    $0x20,%esp
80105e34:	e8 97 dc ff ff       	call   80103ad0 <myproc>
80105e39:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e40:	e8 8b dc ff ff       	call   80103ad0 <myproc>
80105e45:	85 c0                	test   %eax,%eax
80105e47:	0f 85 1e ff ff ff    	jne    80105d6b <trap+0x4b>
80105e4d:	e9 36 ff ff ff       	jmp    80105d88 <trap+0x68>
80105e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105e58:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105e5c:	0f 85 3e ff ff ff    	jne    80105da0 <trap+0x80>
    yield();
80105e62:	e8 89 e4 ff ff       	call   801042f0 <yield>
80105e67:	e9 34 ff ff ff       	jmp    80105da0 <trap+0x80>
80105e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105e70:	e8 5b dc ff ff       	call   80103ad0 <myproc>
80105e75:	8b 70 24             	mov    0x24(%eax),%esi
80105e78:	85 f6                	test   %esi,%esi
80105e7a:	0f 85 40 01 00 00    	jne    80105fc0 <trap+0x2a0>
    myproc()->tf = tf;
80105e80:	e8 4b dc ff ff       	call   80103ad0 <myproc>
80105e85:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105e88:	e8 d3 ee ff ff       	call   80104d60 <syscall>
    if(myproc()->killed)
80105e8d:	e8 3e dc ff ff       	call   80103ad0 <myproc>
80105e92:	8b 48 24             	mov    0x24(%eax),%ecx
80105e95:	85 c9                	test   %ecx,%ecx
80105e97:	0f 84 29 ff ff ff    	je     80105dc6 <trap+0xa6>
}
80105e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea0:	5b                   	pop    %ebx
80105ea1:	5e                   	pop    %esi
80105ea2:	5f                   	pop    %edi
80105ea3:	5d                   	pop    %ebp
      exit();
80105ea4:	e9 e7 e1 ff ff       	jmp    80104090 <exit>
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105eb0:	8b 7b 38             	mov    0x38(%ebx),%edi
80105eb3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105eb7:	e8 f4 db ff ff       	call   80103ab0 <cpuid>
80105ebc:	57                   	push   %edi
80105ebd:	56                   	push   %esi
80105ebe:	50                   	push   %eax
80105ebf:	68 f4 80 10 80       	push   $0x801080f4
80105ec4:	e8 d7 a7 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105ec9:	e8 a2 cb ff ff       	call   80102a70 <lapiceoi>
    break;
80105ece:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ed1:	e8 fa db ff ff       	call   80103ad0 <myproc>
80105ed6:	85 c0                	test   %eax,%eax
80105ed8:	0f 85 8d fe ff ff    	jne    80105d6b <trap+0x4b>
80105ede:	e9 a5 fe ff ff       	jmp    80105d88 <trap+0x68>
80105ee3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ee7:	90                   	nop
    kbdintr();
80105ee8:	e8 43 ca ff ff       	call   80102930 <kbdintr>
    lapiceoi();
80105eed:	e8 7e cb ff ff       	call   80102a70 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ef2:	e8 d9 db ff ff       	call   80103ad0 <myproc>
80105ef7:	85 c0                	test   %eax,%eax
80105ef9:	0f 85 6c fe ff ff    	jne    80105d6b <trap+0x4b>
80105eff:	e9 84 fe ff ff       	jmp    80105d88 <trap+0x68>
80105f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105f08:	e8 03 03 00 00       	call   80106210 <uartintr>
    lapiceoi();
80105f0d:	e8 5e cb ff ff       	call   80102a70 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f12:	e8 b9 db ff ff       	call   80103ad0 <myproc>
80105f17:	85 c0                	test   %eax,%eax
80105f19:	0f 85 4c fe ff ff    	jne    80105d6b <trap+0x4b>
80105f1f:	e9 64 fe ff ff       	jmp    80105d88 <trap+0x68>
80105f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105f28:	e8 13 c3 ff ff       	call   80102240 <ideintr>
80105f2d:	e9 2b fe ff ff       	jmp    80105d5d <trap+0x3d>
80105f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f38:	0f 20 d6             	mov    %cr2,%esi
  if (tf->err & 0x2) {
80105f3b:	f6 43 34 02          	testb  $0x2,0x34(%ebx)
80105f3f:	0f 84 1d fe ff ff    	je     80105d62 <trap+0x42>
    pte_t *pte = walkpgdir(myproc()->pgdir, (void *)va, 0);
80105f45:	e8 86 db ff ff       	call   80103ad0 <myproc>
80105f4a:	83 ec 04             	sub    $0x4,%esp
80105f4d:	6a 00                	push   $0x0
80105f4f:	56                   	push   %esi
80105f50:	ff 70 04             	push   0x4(%eax)
80105f53:	e8 78 0f 00 00       	call   80106ed0 <walkpgdir>
    if (pte == 0) {
80105f58:	83 c4 10             	add    $0x10,%esp
    pte_t *pte = walkpgdir(myproc()->pgdir, (void *)va, 0);
80105f5b:	89 c6                	mov    %eax,%esi
    if (pte == 0) {
80105f5d:	85 c0                	test   %eax,%eax
80105f5f:	0f 84 19 01 00 00    	je     8010607e <trap+0x35e>
    if (*pte & PTE_COW) {
80105f65:	8b 00                	mov    (%eax),%eax
80105f67:	f6 c4 02             	test   $0x2,%ah
80105f6a:	0f 84 f2 fd ff ff    	je     80105d62 <trap+0x42>
      if (refcount(P2V(PTE_ADDR(*pte))) > 1) {
80105f70:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105f75:	83 ec 0c             	sub    $0xc,%esp
80105f78:	05 00 00 00 80       	add    $0x80000000,%eax
80105f7d:	50                   	push   %eax
80105f7e:	e8 0d c8 ff ff       	call   80102790 <refcount>
80105f83:	83 c4 10             	add    $0x10,%esp
80105f86:	83 f8 01             	cmp    $0x1,%eax
80105f89:	7f 79                	jg     80106004 <trap+0x2e4>
        *pte &= ~PTE_COW;
80105f8b:	8b 06                	mov    (%esi),%eax
80105f8d:	80 e4 fd             	and    $0xfd,%ah
80105f90:	83 c8 02             	or     $0x2,%eax
80105f93:	89 06                	mov    %eax,(%esi)
      lcr3(V2P(myproc()->pgdir));
80105f95:	e8 36 db ff ff       	call   80103ad0 <myproc>
80105f9a:	8b 40 04             	mov    0x4(%eax),%eax
80105f9d:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105fa2:	0f 22 d8             	mov    %eax,%cr3
}
80105fa5:	e9 b8 fd ff ff       	jmp    80105d62 <trap+0x42>
80105faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105fb0:	e8 db e0 ff ff       	call   80104090 <exit>
80105fb5:	e9 ce fd ff ff       	jmp    80105d88 <trap+0x68>
80105fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105fc0:	e8 cb e0 ff ff       	call   80104090 <exit>
80105fc5:	e9 b6 fe ff ff       	jmp    80105e80 <trap+0x160>
80105fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105fd0:	83 ec 0c             	sub    $0xc,%esp
80105fd3:	68 80 cc 14 80       	push   $0x8014cc80
80105fd8:	e8 c3 e8 ff ff       	call   801048a0 <acquire>
      wakeup(&ticks);
80105fdd:	c7 04 24 60 cc 14 80 	movl   $0x8014cc60,(%esp)
      ticks++;
80105fe4:	83 05 60 cc 14 80 01 	addl   $0x1,0x8014cc60
      wakeup(&ticks);
80105feb:	e8 10 e4 ff ff       	call   80104400 <wakeup>
      release(&tickslock);
80105ff0:	c7 04 24 80 cc 14 80 	movl   $0x8014cc80,(%esp)
80105ff7:	e8 44 e8 ff ff       	call   80104840 <release>
80105ffc:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105fff:	e9 59 fd ff ff       	jmp    80105d5d <trap+0x3d>
        char *mem = kalloc();
80106004:	e8 a7 c6 ff ff       	call   801026b0 <kalloc>
80106009:	89 c7                	mov    %eax,%edi
        if (mem == 0) {
8010600b:	85 c0                	test   %eax,%eax
8010600d:	74 7c                	je     8010608b <trap+0x36b>
        memmove(mem, (char *)P2V(PTE_ADDR(*pte)), PGSIZE);
8010600f:	83 ec 04             	sub    $0x4,%esp
80106012:	68 00 10 00 00       	push   $0x1000
80106017:	8b 06                	mov    (%esi),%eax
80106019:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010601e:	05 00 00 00 80       	add    $0x80000000,%eax
80106023:	50                   	push   %eax
80106024:	57                   	push   %edi
        *pte = V2P(mem) | PTE_P | PTE_W | PTE_U;
80106025:	81 c7 00 00 00 80    	add    $0x80000000,%edi
        memmove(mem, (char *)P2V(PTE_ADDR(*pte)), PGSIZE);
8010602b:	e8 d0 e9 ff ff       	call   80104a00 <memmove>
        *pte = V2P(mem) | PTE_P | PTE_W | PTE_U;
80106030:	89 f8                	mov    %edi,%eax
        decr_ref_count(P2V(PTE_ADDR(*pte)));  // Decrement the reference count of the original page
80106032:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
        *pte = V2P(mem) | PTE_P | PTE_W | PTE_U;
80106038:	83 c8 07             	or     $0x7,%eax
8010603b:	89 06                	mov    %eax,(%esi)
        decr_ref_count(P2V(PTE_ADDR(*pte)));  // Decrement the reference count of the original page
8010603d:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80106043:	89 04 24             	mov    %eax,(%esp)
80106046:	e8 85 c7 ff ff       	call   801027d0 <decr_ref_count>
8010604b:	83 c4 10             	add    $0x10,%esp
8010604e:	e9 42 ff ff ff       	jmp    80105f95 <trap+0x275>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106053:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106056:	8b 73 38             	mov    0x38(%ebx),%esi
80106059:	e8 52 da ff ff       	call   80103ab0 <cpuid>
8010605e:	83 ec 0c             	sub    $0xc,%esp
80106061:	57                   	push   %edi
80106062:	56                   	push   %esi
80106063:	50                   	push   %eax
80106064:	ff 73 30             	push   0x30(%ebx)
80106067:	68 60 81 10 80       	push   $0x80108160
8010606c:	e8 2f a6 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80106071:	83 c4 14             	add    $0x14,%esp
80106074:	68 ee 80 10 80       	push   $0x801080ee
80106079:	e8 02 a3 ff ff       	call   80100380 <panic>
      panic("page fault with no page table entry");
8010607e:	83 ec 0c             	sub    $0xc,%esp
80106081:	68 18 81 10 80       	push   $0x80108118
80106086:	e8 f5 a2 ff ff       	call   80100380 <panic>
          panic("out of memory during CoW page fault");
8010608b:	83 ec 0c             	sub    $0xc,%esp
8010608e:	68 3c 81 10 80       	push   $0x8010813c
80106093:	e8 e8 a2 ff ff       	call   80100380 <panic>
80106098:	66 90                	xchg   %ax,%ax
8010609a:	66 90                	xchg   %ax,%ax
8010609c:	66 90                	xchg   %ax,%ax
8010609e:	66 90                	xchg   %ax,%ax

801060a0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801060a0:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
801060a5:	85 c0                	test   %eax,%eax
801060a7:	74 17                	je     801060c0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060a9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060ae:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801060af:	a8 01                	test   $0x1,%al
801060b1:	74 0d                	je     801060c0 <uartgetc+0x20>
801060b3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060b8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801060b9:	0f b6 c0             	movzbl %al,%eax
801060bc:	c3                   	ret    
801060bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801060c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060c5:	c3                   	ret    
801060c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060cd:	8d 76 00             	lea    0x0(%esi),%esi

801060d0 <uartinit>:
{
801060d0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060d1:	31 c9                	xor    %ecx,%ecx
801060d3:	89 c8                	mov    %ecx,%eax
801060d5:	89 e5                	mov    %esp,%ebp
801060d7:	57                   	push   %edi
801060d8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801060dd:	56                   	push   %esi
801060de:	89 fa                	mov    %edi,%edx
801060e0:	53                   	push   %ebx
801060e1:	83 ec 1c             	sub    $0x1c,%esp
801060e4:	ee                   	out    %al,(%dx)
801060e5:	be fb 03 00 00       	mov    $0x3fb,%esi
801060ea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801060ef:	89 f2                	mov    %esi,%edx
801060f1:	ee                   	out    %al,(%dx)
801060f2:	b8 0c 00 00 00       	mov    $0xc,%eax
801060f7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060fc:	ee                   	out    %al,(%dx)
801060fd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106102:	89 c8                	mov    %ecx,%eax
80106104:	89 da                	mov    %ebx,%edx
80106106:	ee                   	out    %al,(%dx)
80106107:	b8 03 00 00 00       	mov    $0x3,%eax
8010610c:	89 f2                	mov    %esi,%edx
8010610e:	ee                   	out    %al,(%dx)
8010610f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106114:	89 c8                	mov    %ecx,%eax
80106116:	ee                   	out    %al,(%dx)
80106117:	b8 01 00 00 00       	mov    $0x1,%eax
8010611c:	89 da                	mov    %ebx,%edx
8010611e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010611f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106124:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106125:	3c ff                	cmp    $0xff,%al
80106127:	74 78                	je     801061a1 <uartinit+0xd1>
  uart = 1;
80106129:	c7 05 c0 d4 14 80 01 	movl   $0x1,0x8014d4c0
80106130:	00 00 00 
80106133:	89 fa                	mov    %edi,%edx
80106135:	ec                   	in     (%dx),%al
80106136:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010613b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010613c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010613f:	bf a0 82 10 80       	mov    $0x801082a0,%edi
80106144:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106149:	6a 00                	push   $0x0
8010614b:	6a 04                	push   $0x4
8010614d:	e8 2e c3 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106152:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106156:	83 c4 10             	add    $0x10,%esp
80106159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106160:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
80106165:	bb 80 00 00 00       	mov    $0x80,%ebx
8010616a:	85 c0                	test   %eax,%eax
8010616c:	75 14                	jne    80106182 <uartinit+0xb2>
8010616e:	eb 23                	jmp    80106193 <uartinit+0xc3>
    microdelay(10);
80106170:	83 ec 0c             	sub    $0xc,%esp
80106173:	6a 0a                	push   $0xa
80106175:	e8 16 c9 ff ff       	call   80102a90 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010617a:	83 c4 10             	add    $0x10,%esp
8010617d:	83 eb 01             	sub    $0x1,%ebx
80106180:	74 07                	je     80106189 <uartinit+0xb9>
80106182:	89 f2                	mov    %esi,%edx
80106184:	ec                   	in     (%dx),%al
80106185:	a8 20                	test   $0x20,%al
80106187:	74 e7                	je     80106170 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106189:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010618d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106192:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106193:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106197:	83 c7 01             	add    $0x1,%edi
8010619a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010619d:	84 c0                	test   %al,%al
8010619f:	75 bf                	jne    80106160 <uartinit+0x90>
}
801061a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061a4:	5b                   	pop    %ebx
801061a5:	5e                   	pop    %esi
801061a6:	5f                   	pop    %edi
801061a7:	5d                   	pop    %ebp
801061a8:	c3                   	ret    
801061a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061b0 <uartputc>:
  if(!uart)
801061b0:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
801061b5:	85 c0                	test   %eax,%eax
801061b7:	74 47                	je     80106200 <uartputc+0x50>
{
801061b9:	55                   	push   %ebp
801061ba:	89 e5                	mov    %esp,%ebp
801061bc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061bd:	be fd 03 00 00       	mov    $0x3fd,%esi
801061c2:	53                   	push   %ebx
801061c3:	bb 80 00 00 00       	mov    $0x80,%ebx
801061c8:	eb 18                	jmp    801061e2 <uartputc+0x32>
801061ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801061d0:	83 ec 0c             	sub    $0xc,%esp
801061d3:	6a 0a                	push   $0xa
801061d5:	e8 b6 c8 ff ff       	call   80102a90 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061da:	83 c4 10             	add    $0x10,%esp
801061dd:	83 eb 01             	sub    $0x1,%ebx
801061e0:	74 07                	je     801061e9 <uartputc+0x39>
801061e2:	89 f2                	mov    %esi,%edx
801061e4:	ec                   	in     (%dx),%al
801061e5:	a8 20                	test   $0x20,%al
801061e7:	74 e7                	je     801061d0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061e9:	8b 45 08             	mov    0x8(%ebp),%eax
801061ec:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061f1:	ee                   	out    %al,(%dx)
}
801061f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061f5:	5b                   	pop    %ebx
801061f6:	5e                   	pop    %esi
801061f7:	5d                   	pop    %ebp
801061f8:	c3                   	ret    
801061f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106200:	c3                   	ret    
80106201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010620f:	90                   	nop

80106210 <uartintr>:

void
uartintr(void)
{
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
80106213:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106216:	68 a0 60 10 80       	push   $0x801060a0
8010621b:	e8 60 a6 ff ff       	call   80100880 <consoleintr>
}
80106220:	83 c4 10             	add    $0x10,%esp
80106223:	c9                   	leave  
80106224:	c3                   	ret    

80106225 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106225:	6a 00                	push   $0x0
  pushl $0
80106227:	6a 00                	push   $0x0
  jmp alltraps
80106229:	e9 11 fa ff ff       	jmp    80105c3f <alltraps>

8010622e <vector1>:
.globl vector1
vector1:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $1
80106230:	6a 01                	push   $0x1
  jmp alltraps
80106232:	e9 08 fa ff ff       	jmp    80105c3f <alltraps>

80106237 <vector2>:
.globl vector2
vector2:
  pushl $0
80106237:	6a 00                	push   $0x0
  pushl $2
80106239:	6a 02                	push   $0x2
  jmp alltraps
8010623b:	e9 ff f9 ff ff       	jmp    80105c3f <alltraps>

80106240 <vector3>:
.globl vector3
vector3:
  pushl $0
80106240:	6a 00                	push   $0x0
  pushl $3
80106242:	6a 03                	push   $0x3
  jmp alltraps
80106244:	e9 f6 f9 ff ff       	jmp    80105c3f <alltraps>

80106249 <vector4>:
.globl vector4
vector4:
  pushl $0
80106249:	6a 00                	push   $0x0
  pushl $4
8010624b:	6a 04                	push   $0x4
  jmp alltraps
8010624d:	e9 ed f9 ff ff       	jmp    80105c3f <alltraps>

80106252 <vector5>:
.globl vector5
vector5:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $5
80106254:	6a 05                	push   $0x5
  jmp alltraps
80106256:	e9 e4 f9 ff ff       	jmp    80105c3f <alltraps>

8010625b <vector6>:
.globl vector6
vector6:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $6
8010625d:	6a 06                	push   $0x6
  jmp alltraps
8010625f:	e9 db f9 ff ff       	jmp    80105c3f <alltraps>

80106264 <vector7>:
.globl vector7
vector7:
  pushl $0
80106264:	6a 00                	push   $0x0
  pushl $7
80106266:	6a 07                	push   $0x7
  jmp alltraps
80106268:	e9 d2 f9 ff ff       	jmp    80105c3f <alltraps>

8010626d <vector8>:
.globl vector8
vector8:
  pushl $8
8010626d:	6a 08                	push   $0x8
  jmp alltraps
8010626f:	e9 cb f9 ff ff       	jmp    80105c3f <alltraps>

80106274 <vector9>:
.globl vector9
vector9:
  pushl $0
80106274:	6a 00                	push   $0x0
  pushl $9
80106276:	6a 09                	push   $0x9
  jmp alltraps
80106278:	e9 c2 f9 ff ff       	jmp    80105c3f <alltraps>

8010627d <vector10>:
.globl vector10
vector10:
  pushl $10
8010627d:	6a 0a                	push   $0xa
  jmp alltraps
8010627f:	e9 bb f9 ff ff       	jmp    80105c3f <alltraps>

80106284 <vector11>:
.globl vector11
vector11:
  pushl $11
80106284:	6a 0b                	push   $0xb
  jmp alltraps
80106286:	e9 b4 f9 ff ff       	jmp    80105c3f <alltraps>

8010628b <vector12>:
.globl vector12
vector12:
  pushl $12
8010628b:	6a 0c                	push   $0xc
  jmp alltraps
8010628d:	e9 ad f9 ff ff       	jmp    80105c3f <alltraps>

80106292 <vector13>:
.globl vector13
vector13:
  pushl $13
80106292:	6a 0d                	push   $0xd
  jmp alltraps
80106294:	e9 a6 f9 ff ff       	jmp    80105c3f <alltraps>

80106299 <vector14>:
.globl vector14
vector14:
  pushl $14
80106299:	6a 0e                	push   $0xe
  jmp alltraps
8010629b:	e9 9f f9 ff ff       	jmp    80105c3f <alltraps>

801062a0 <vector15>:
.globl vector15
vector15:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $15
801062a2:	6a 0f                	push   $0xf
  jmp alltraps
801062a4:	e9 96 f9 ff ff       	jmp    80105c3f <alltraps>

801062a9 <vector16>:
.globl vector16
vector16:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $16
801062ab:	6a 10                	push   $0x10
  jmp alltraps
801062ad:	e9 8d f9 ff ff       	jmp    80105c3f <alltraps>

801062b2 <vector17>:
.globl vector17
vector17:
  pushl $17
801062b2:	6a 11                	push   $0x11
  jmp alltraps
801062b4:	e9 86 f9 ff ff       	jmp    80105c3f <alltraps>

801062b9 <vector18>:
.globl vector18
vector18:
  pushl $0
801062b9:	6a 00                	push   $0x0
  pushl $18
801062bb:	6a 12                	push   $0x12
  jmp alltraps
801062bd:	e9 7d f9 ff ff       	jmp    80105c3f <alltraps>

801062c2 <vector19>:
.globl vector19
vector19:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $19
801062c4:	6a 13                	push   $0x13
  jmp alltraps
801062c6:	e9 74 f9 ff ff       	jmp    80105c3f <alltraps>

801062cb <vector20>:
.globl vector20
vector20:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $20
801062cd:	6a 14                	push   $0x14
  jmp alltraps
801062cf:	e9 6b f9 ff ff       	jmp    80105c3f <alltraps>

801062d4 <vector21>:
.globl vector21
vector21:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $21
801062d6:	6a 15                	push   $0x15
  jmp alltraps
801062d8:	e9 62 f9 ff ff       	jmp    80105c3f <alltraps>

801062dd <vector22>:
.globl vector22
vector22:
  pushl $0
801062dd:	6a 00                	push   $0x0
  pushl $22
801062df:	6a 16                	push   $0x16
  jmp alltraps
801062e1:	e9 59 f9 ff ff       	jmp    80105c3f <alltraps>

801062e6 <vector23>:
.globl vector23
vector23:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $23
801062e8:	6a 17                	push   $0x17
  jmp alltraps
801062ea:	e9 50 f9 ff ff       	jmp    80105c3f <alltraps>

801062ef <vector24>:
.globl vector24
vector24:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $24
801062f1:	6a 18                	push   $0x18
  jmp alltraps
801062f3:	e9 47 f9 ff ff       	jmp    80105c3f <alltraps>

801062f8 <vector25>:
.globl vector25
vector25:
  pushl $0
801062f8:	6a 00                	push   $0x0
  pushl $25
801062fa:	6a 19                	push   $0x19
  jmp alltraps
801062fc:	e9 3e f9 ff ff       	jmp    80105c3f <alltraps>

80106301 <vector26>:
.globl vector26
vector26:
  pushl $0
80106301:	6a 00                	push   $0x0
  pushl $26
80106303:	6a 1a                	push   $0x1a
  jmp alltraps
80106305:	e9 35 f9 ff ff       	jmp    80105c3f <alltraps>

8010630a <vector27>:
.globl vector27
vector27:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $27
8010630c:	6a 1b                	push   $0x1b
  jmp alltraps
8010630e:	e9 2c f9 ff ff       	jmp    80105c3f <alltraps>

80106313 <vector28>:
.globl vector28
vector28:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $28
80106315:	6a 1c                	push   $0x1c
  jmp alltraps
80106317:	e9 23 f9 ff ff       	jmp    80105c3f <alltraps>

8010631c <vector29>:
.globl vector29
vector29:
  pushl $0
8010631c:	6a 00                	push   $0x0
  pushl $29
8010631e:	6a 1d                	push   $0x1d
  jmp alltraps
80106320:	e9 1a f9 ff ff       	jmp    80105c3f <alltraps>

80106325 <vector30>:
.globl vector30
vector30:
  pushl $0
80106325:	6a 00                	push   $0x0
  pushl $30
80106327:	6a 1e                	push   $0x1e
  jmp alltraps
80106329:	e9 11 f9 ff ff       	jmp    80105c3f <alltraps>

8010632e <vector31>:
.globl vector31
vector31:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $31
80106330:	6a 1f                	push   $0x1f
  jmp alltraps
80106332:	e9 08 f9 ff ff       	jmp    80105c3f <alltraps>

80106337 <vector32>:
.globl vector32
vector32:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $32
80106339:	6a 20                	push   $0x20
  jmp alltraps
8010633b:	e9 ff f8 ff ff       	jmp    80105c3f <alltraps>

80106340 <vector33>:
.globl vector33
vector33:
  pushl $0
80106340:	6a 00                	push   $0x0
  pushl $33
80106342:	6a 21                	push   $0x21
  jmp alltraps
80106344:	e9 f6 f8 ff ff       	jmp    80105c3f <alltraps>

80106349 <vector34>:
.globl vector34
vector34:
  pushl $0
80106349:	6a 00                	push   $0x0
  pushl $34
8010634b:	6a 22                	push   $0x22
  jmp alltraps
8010634d:	e9 ed f8 ff ff       	jmp    80105c3f <alltraps>

80106352 <vector35>:
.globl vector35
vector35:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $35
80106354:	6a 23                	push   $0x23
  jmp alltraps
80106356:	e9 e4 f8 ff ff       	jmp    80105c3f <alltraps>

8010635b <vector36>:
.globl vector36
vector36:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $36
8010635d:	6a 24                	push   $0x24
  jmp alltraps
8010635f:	e9 db f8 ff ff       	jmp    80105c3f <alltraps>

80106364 <vector37>:
.globl vector37
vector37:
  pushl $0
80106364:	6a 00                	push   $0x0
  pushl $37
80106366:	6a 25                	push   $0x25
  jmp alltraps
80106368:	e9 d2 f8 ff ff       	jmp    80105c3f <alltraps>

8010636d <vector38>:
.globl vector38
vector38:
  pushl $0
8010636d:	6a 00                	push   $0x0
  pushl $38
8010636f:	6a 26                	push   $0x26
  jmp alltraps
80106371:	e9 c9 f8 ff ff       	jmp    80105c3f <alltraps>

80106376 <vector39>:
.globl vector39
vector39:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $39
80106378:	6a 27                	push   $0x27
  jmp alltraps
8010637a:	e9 c0 f8 ff ff       	jmp    80105c3f <alltraps>

8010637f <vector40>:
.globl vector40
vector40:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $40
80106381:	6a 28                	push   $0x28
  jmp alltraps
80106383:	e9 b7 f8 ff ff       	jmp    80105c3f <alltraps>

80106388 <vector41>:
.globl vector41
vector41:
  pushl $0
80106388:	6a 00                	push   $0x0
  pushl $41
8010638a:	6a 29                	push   $0x29
  jmp alltraps
8010638c:	e9 ae f8 ff ff       	jmp    80105c3f <alltraps>

80106391 <vector42>:
.globl vector42
vector42:
  pushl $0
80106391:	6a 00                	push   $0x0
  pushl $42
80106393:	6a 2a                	push   $0x2a
  jmp alltraps
80106395:	e9 a5 f8 ff ff       	jmp    80105c3f <alltraps>

8010639a <vector43>:
.globl vector43
vector43:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $43
8010639c:	6a 2b                	push   $0x2b
  jmp alltraps
8010639e:	e9 9c f8 ff ff       	jmp    80105c3f <alltraps>

801063a3 <vector44>:
.globl vector44
vector44:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $44
801063a5:	6a 2c                	push   $0x2c
  jmp alltraps
801063a7:	e9 93 f8 ff ff       	jmp    80105c3f <alltraps>

801063ac <vector45>:
.globl vector45
vector45:
  pushl $0
801063ac:	6a 00                	push   $0x0
  pushl $45
801063ae:	6a 2d                	push   $0x2d
  jmp alltraps
801063b0:	e9 8a f8 ff ff       	jmp    80105c3f <alltraps>

801063b5 <vector46>:
.globl vector46
vector46:
  pushl $0
801063b5:	6a 00                	push   $0x0
  pushl $46
801063b7:	6a 2e                	push   $0x2e
  jmp alltraps
801063b9:	e9 81 f8 ff ff       	jmp    80105c3f <alltraps>

801063be <vector47>:
.globl vector47
vector47:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $47
801063c0:	6a 2f                	push   $0x2f
  jmp alltraps
801063c2:	e9 78 f8 ff ff       	jmp    80105c3f <alltraps>

801063c7 <vector48>:
.globl vector48
vector48:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $48
801063c9:	6a 30                	push   $0x30
  jmp alltraps
801063cb:	e9 6f f8 ff ff       	jmp    80105c3f <alltraps>

801063d0 <vector49>:
.globl vector49
vector49:
  pushl $0
801063d0:	6a 00                	push   $0x0
  pushl $49
801063d2:	6a 31                	push   $0x31
  jmp alltraps
801063d4:	e9 66 f8 ff ff       	jmp    80105c3f <alltraps>

801063d9 <vector50>:
.globl vector50
vector50:
  pushl $0
801063d9:	6a 00                	push   $0x0
  pushl $50
801063db:	6a 32                	push   $0x32
  jmp alltraps
801063dd:	e9 5d f8 ff ff       	jmp    80105c3f <alltraps>

801063e2 <vector51>:
.globl vector51
vector51:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $51
801063e4:	6a 33                	push   $0x33
  jmp alltraps
801063e6:	e9 54 f8 ff ff       	jmp    80105c3f <alltraps>

801063eb <vector52>:
.globl vector52
vector52:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $52
801063ed:	6a 34                	push   $0x34
  jmp alltraps
801063ef:	e9 4b f8 ff ff       	jmp    80105c3f <alltraps>

801063f4 <vector53>:
.globl vector53
vector53:
  pushl $0
801063f4:	6a 00                	push   $0x0
  pushl $53
801063f6:	6a 35                	push   $0x35
  jmp alltraps
801063f8:	e9 42 f8 ff ff       	jmp    80105c3f <alltraps>

801063fd <vector54>:
.globl vector54
vector54:
  pushl $0
801063fd:	6a 00                	push   $0x0
  pushl $54
801063ff:	6a 36                	push   $0x36
  jmp alltraps
80106401:	e9 39 f8 ff ff       	jmp    80105c3f <alltraps>

80106406 <vector55>:
.globl vector55
vector55:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $55
80106408:	6a 37                	push   $0x37
  jmp alltraps
8010640a:	e9 30 f8 ff ff       	jmp    80105c3f <alltraps>

8010640f <vector56>:
.globl vector56
vector56:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $56
80106411:	6a 38                	push   $0x38
  jmp alltraps
80106413:	e9 27 f8 ff ff       	jmp    80105c3f <alltraps>

80106418 <vector57>:
.globl vector57
vector57:
  pushl $0
80106418:	6a 00                	push   $0x0
  pushl $57
8010641a:	6a 39                	push   $0x39
  jmp alltraps
8010641c:	e9 1e f8 ff ff       	jmp    80105c3f <alltraps>

80106421 <vector58>:
.globl vector58
vector58:
  pushl $0
80106421:	6a 00                	push   $0x0
  pushl $58
80106423:	6a 3a                	push   $0x3a
  jmp alltraps
80106425:	e9 15 f8 ff ff       	jmp    80105c3f <alltraps>

8010642a <vector59>:
.globl vector59
vector59:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $59
8010642c:	6a 3b                	push   $0x3b
  jmp alltraps
8010642e:	e9 0c f8 ff ff       	jmp    80105c3f <alltraps>

80106433 <vector60>:
.globl vector60
vector60:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $60
80106435:	6a 3c                	push   $0x3c
  jmp alltraps
80106437:	e9 03 f8 ff ff       	jmp    80105c3f <alltraps>

8010643c <vector61>:
.globl vector61
vector61:
  pushl $0
8010643c:	6a 00                	push   $0x0
  pushl $61
8010643e:	6a 3d                	push   $0x3d
  jmp alltraps
80106440:	e9 fa f7 ff ff       	jmp    80105c3f <alltraps>

80106445 <vector62>:
.globl vector62
vector62:
  pushl $0
80106445:	6a 00                	push   $0x0
  pushl $62
80106447:	6a 3e                	push   $0x3e
  jmp alltraps
80106449:	e9 f1 f7 ff ff       	jmp    80105c3f <alltraps>

8010644e <vector63>:
.globl vector63
vector63:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $63
80106450:	6a 3f                	push   $0x3f
  jmp alltraps
80106452:	e9 e8 f7 ff ff       	jmp    80105c3f <alltraps>

80106457 <vector64>:
.globl vector64
vector64:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $64
80106459:	6a 40                	push   $0x40
  jmp alltraps
8010645b:	e9 df f7 ff ff       	jmp    80105c3f <alltraps>

80106460 <vector65>:
.globl vector65
vector65:
  pushl $0
80106460:	6a 00                	push   $0x0
  pushl $65
80106462:	6a 41                	push   $0x41
  jmp alltraps
80106464:	e9 d6 f7 ff ff       	jmp    80105c3f <alltraps>

80106469 <vector66>:
.globl vector66
vector66:
  pushl $0
80106469:	6a 00                	push   $0x0
  pushl $66
8010646b:	6a 42                	push   $0x42
  jmp alltraps
8010646d:	e9 cd f7 ff ff       	jmp    80105c3f <alltraps>

80106472 <vector67>:
.globl vector67
vector67:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $67
80106474:	6a 43                	push   $0x43
  jmp alltraps
80106476:	e9 c4 f7 ff ff       	jmp    80105c3f <alltraps>

8010647b <vector68>:
.globl vector68
vector68:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $68
8010647d:	6a 44                	push   $0x44
  jmp alltraps
8010647f:	e9 bb f7 ff ff       	jmp    80105c3f <alltraps>

80106484 <vector69>:
.globl vector69
vector69:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $69
80106486:	6a 45                	push   $0x45
  jmp alltraps
80106488:	e9 b2 f7 ff ff       	jmp    80105c3f <alltraps>

8010648d <vector70>:
.globl vector70
vector70:
  pushl $0
8010648d:	6a 00                	push   $0x0
  pushl $70
8010648f:	6a 46                	push   $0x46
  jmp alltraps
80106491:	e9 a9 f7 ff ff       	jmp    80105c3f <alltraps>

80106496 <vector71>:
.globl vector71
vector71:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $71
80106498:	6a 47                	push   $0x47
  jmp alltraps
8010649a:	e9 a0 f7 ff ff       	jmp    80105c3f <alltraps>

8010649f <vector72>:
.globl vector72
vector72:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $72
801064a1:	6a 48                	push   $0x48
  jmp alltraps
801064a3:	e9 97 f7 ff ff       	jmp    80105c3f <alltraps>

801064a8 <vector73>:
.globl vector73
vector73:
  pushl $0
801064a8:	6a 00                	push   $0x0
  pushl $73
801064aa:	6a 49                	push   $0x49
  jmp alltraps
801064ac:	e9 8e f7 ff ff       	jmp    80105c3f <alltraps>

801064b1 <vector74>:
.globl vector74
vector74:
  pushl $0
801064b1:	6a 00                	push   $0x0
  pushl $74
801064b3:	6a 4a                	push   $0x4a
  jmp alltraps
801064b5:	e9 85 f7 ff ff       	jmp    80105c3f <alltraps>

801064ba <vector75>:
.globl vector75
vector75:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $75
801064bc:	6a 4b                	push   $0x4b
  jmp alltraps
801064be:	e9 7c f7 ff ff       	jmp    80105c3f <alltraps>

801064c3 <vector76>:
.globl vector76
vector76:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $76
801064c5:	6a 4c                	push   $0x4c
  jmp alltraps
801064c7:	e9 73 f7 ff ff       	jmp    80105c3f <alltraps>

801064cc <vector77>:
.globl vector77
vector77:
  pushl $0
801064cc:	6a 00                	push   $0x0
  pushl $77
801064ce:	6a 4d                	push   $0x4d
  jmp alltraps
801064d0:	e9 6a f7 ff ff       	jmp    80105c3f <alltraps>

801064d5 <vector78>:
.globl vector78
vector78:
  pushl $0
801064d5:	6a 00                	push   $0x0
  pushl $78
801064d7:	6a 4e                	push   $0x4e
  jmp alltraps
801064d9:	e9 61 f7 ff ff       	jmp    80105c3f <alltraps>

801064de <vector79>:
.globl vector79
vector79:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $79
801064e0:	6a 4f                	push   $0x4f
  jmp alltraps
801064e2:	e9 58 f7 ff ff       	jmp    80105c3f <alltraps>

801064e7 <vector80>:
.globl vector80
vector80:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $80
801064e9:	6a 50                	push   $0x50
  jmp alltraps
801064eb:	e9 4f f7 ff ff       	jmp    80105c3f <alltraps>

801064f0 <vector81>:
.globl vector81
vector81:
  pushl $0
801064f0:	6a 00                	push   $0x0
  pushl $81
801064f2:	6a 51                	push   $0x51
  jmp alltraps
801064f4:	e9 46 f7 ff ff       	jmp    80105c3f <alltraps>

801064f9 <vector82>:
.globl vector82
vector82:
  pushl $0
801064f9:	6a 00                	push   $0x0
  pushl $82
801064fb:	6a 52                	push   $0x52
  jmp alltraps
801064fd:	e9 3d f7 ff ff       	jmp    80105c3f <alltraps>

80106502 <vector83>:
.globl vector83
vector83:
  pushl $0
80106502:	6a 00                	push   $0x0
  pushl $83
80106504:	6a 53                	push   $0x53
  jmp alltraps
80106506:	e9 34 f7 ff ff       	jmp    80105c3f <alltraps>

8010650b <vector84>:
.globl vector84
vector84:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $84
8010650d:	6a 54                	push   $0x54
  jmp alltraps
8010650f:	e9 2b f7 ff ff       	jmp    80105c3f <alltraps>

80106514 <vector85>:
.globl vector85
vector85:
  pushl $0
80106514:	6a 00                	push   $0x0
  pushl $85
80106516:	6a 55                	push   $0x55
  jmp alltraps
80106518:	e9 22 f7 ff ff       	jmp    80105c3f <alltraps>

8010651d <vector86>:
.globl vector86
vector86:
  pushl $0
8010651d:	6a 00                	push   $0x0
  pushl $86
8010651f:	6a 56                	push   $0x56
  jmp alltraps
80106521:	e9 19 f7 ff ff       	jmp    80105c3f <alltraps>

80106526 <vector87>:
.globl vector87
vector87:
  pushl $0
80106526:	6a 00                	push   $0x0
  pushl $87
80106528:	6a 57                	push   $0x57
  jmp alltraps
8010652a:	e9 10 f7 ff ff       	jmp    80105c3f <alltraps>

8010652f <vector88>:
.globl vector88
vector88:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $88
80106531:	6a 58                	push   $0x58
  jmp alltraps
80106533:	e9 07 f7 ff ff       	jmp    80105c3f <alltraps>

80106538 <vector89>:
.globl vector89
vector89:
  pushl $0
80106538:	6a 00                	push   $0x0
  pushl $89
8010653a:	6a 59                	push   $0x59
  jmp alltraps
8010653c:	e9 fe f6 ff ff       	jmp    80105c3f <alltraps>

80106541 <vector90>:
.globl vector90
vector90:
  pushl $0
80106541:	6a 00                	push   $0x0
  pushl $90
80106543:	6a 5a                	push   $0x5a
  jmp alltraps
80106545:	e9 f5 f6 ff ff       	jmp    80105c3f <alltraps>

8010654a <vector91>:
.globl vector91
vector91:
  pushl $0
8010654a:	6a 00                	push   $0x0
  pushl $91
8010654c:	6a 5b                	push   $0x5b
  jmp alltraps
8010654e:	e9 ec f6 ff ff       	jmp    80105c3f <alltraps>

80106553 <vector92>:
.globl vector92
vector92:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $92
80106555:	6a 5c                	push   $0x5c
  jmp alltraps
80106557:	e9 e3 f6 ff ff       	jmp    80105c3f <alltraps>

8010655c <vector93>:
.globl vector93
vector93:
  pushl $0
8010655c:	6a 00                	push   $0x0
  pushl $93
8010655e:	6a 5d                	push   $0x5d
  jmp alltraps
80106560:	e9 da f6 ff ff       	jmp    80105c3f <alltraps>

80106565 <vector94>:
.globl vector94
vector94:
  pushl $0
80106565:	6a 00                	push   $0x0
  pushl $94
80106567:	6a 5e                	push   $0x5e
  jmp alltraps
80106569:	e9 d1 f6 ff ff       	jmp    80105c3f <alltraps>

8010656e <vector95>:
.globl vector95
vector95:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $95
80106570:	6a 5f                	push   $0x5f
  jmp alltraps
80106572:	e9 c8 f6 ff ff       	jmp    80105c3f <alltraps>

80106577 <vector96>:
.globl vector96
vector96:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $96
80106579:	6a 60                	push   $0x60
  jmp alltraps
8010657b:	e9 bf f6 ff ff       	jmp    80105c3f <alltraps>

80106580 <vector97>:
.globl vector97
vector97:
  pushl $0
80106580:	6a 00                	push   $0x0
  pushl $97
80106582:	6a 61                	push   $0x61
  jmp alltraps
80106584:	e9 b6 f6 ff ff       	jmp    80105c3f <alltraps>

80106589 <vector98>:
.globl vector98
vector98:
  pushl $0
80106589:	6a 00                	push   $0x0
  pushl $98
8010658b:	6a 62                	push   $0x62
  jmp alltraps
8010658d:	e9 ad f6 ff ff       	jmp    80105c3f <alltraps>

80106592 <vector99>:
.globl vector99
vector99:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $99
80106594:	6a 63                	push   $0x63
  jmp alltraps
80106596:	e9 a4 f6 ff ff       	jmp    80105c3f <alltraps>

8010659b <vector100>:
.globl vector100
vector100:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $100
8010659d:	6a 64                	push   $0x64
  jmp alltraps
8010659f:	e9 9b f6 ff ff       	jmp    80105c3f <alltraps>

801065a4 <vector101>:
.globl vector101
vector101:
  pushl $0
801065a4:	6a 00                	push   $0x0
  pushl $101
801065a6:	6a 65                	push   $0x65
  jmp alltraps
801065a8:	e9 92 f6 ff ff       	jmp    80105c3f <alltraps>

801065ad <vector102>:
.globl vector102
vector102:
  pushl $0
801065ad:	6a 00                	push   $0x0
  pushl $102
801065af:	6a 66                	push   $0x66
  jmp alltraps
801065b1:	e9 89 f6 ff ff       	jmp    80105c3f <alltraps>

801065b6 <vector103>:
.globl vector103
vector103:
  pushl $0
801065b6:	6a 00                	push   $0x0
  pushl $103
801065b8:	6a 67                	push   $0x67
  jmp alltraps
801065ba:	e9 80 f6 ff ff       	jmp    80105c3f <alltraps>

801065bf <vector104>:
.globl vector104
vector104:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $104
801065c1:	6a 68                	push   $0x68
  jmp alltraps
801065c3:	e9 77 f6 ff ff       	jmp    80105c3f <alltraps>

801065c8 <vector105>:
.globl vector105
vector105:
  pushl $0
801065c8:	6a 00                	push   $0x0
  pushl $105
801065ca:	6a 69                	push   $0x69
  jmp alltraps
801065cc:	e9 6e f6 ff ff       	jmp    80105c3f <alltraps>

801065d1 <vector106>:
.globl vector106
vector106:
  pushl $0
801065d1:	6a 00                	push   $0x0
  pushl $106
801065d3:	6a 6a                	push   $0x6a
  jmp alltraps
801065d5:	e9 65 f6 ff ff       	jmp    80105c3f <alltraps>

801065da <vector107>:
.globl vector107
vector107:
  pushl $0
801065da:	6a 00                	push   $0x0
  pushl $107
801065dc:	6a 6b                	push   $0x6b
  jmp alltraps
801065de:	e9 5c f6 ff ff       	jmp    80105c3f <alltraps>

801065e3 <vector108>:
.globl vector108
vector108:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $108
801065e5:	6a 6c                	push   $0x6c
  jmp alltraps
801065e7:	e9 53 f6 ff ff       	jmp    80105c3f <alltraps>

801065ec <vector109>:
.globl vector109
vector109:
  pushl $0
801065ec:	6a 00                	push   $0x0
  pushl $109
801065ee:	6a 6d                	push   $0x6d
  jmp alltraps
801065f0:	e9 4a f6 ff ff       	jmp    80105c3f <alltraps>

801065f5 <vector110>:
.globl vector110
vector110:
  pushl $0
801065f5:	6a 00                	push   $0x0
  pushl $110
801065f7:	6a 6e                	push   $0x6e
  jmp alltraps
801065f9:	e9 41 f6 ff ff       	jmp    80105c3f <alltraps>

801065fe <vector111>:
.globl vector111
vector111:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $111
80106600:	6a 6f                	push   $0x6f
  jmp alltraps
80106602:	e9 38 f6 ff ff       	jmp    80105c3f <alltraps>

80106607 <vector112>:
.globl vector112
vector112:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $112
80106609:	6a 70                	push   $0x70
  jmp alltraps
8010660b:	e9 2f f6 ff ff       	jmp    80105c3f <alltraps>

80106610 <vector113>:
.globl vector113
vector113:
  pushl $0
80106610:	6a 00                	push   $0x0
  pushl $113
80106612:	6a 71                	push   $0x71
  jmp alltraps
80106614:	e9 26 f6 ff ff       	jmp    80105c3f <alltraps>

80106619 <vector114>:
.globl vector114
vector114:
  pushl $0
80106619:	6a 00                	push   $0x0
  pushl $114
8010661b:	6a 72                	push   $0x72
  jmp alltraps
8010661d:	e9 1d f6 ff ff       	jmp    80105c3f <alltraps>

80106622 <vector115>:
.globl vector115
vector115:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $115
80106624:	6a 73                	push   $0x73
  jmp alltraps
80106626:	e9 14 f6 ff ff       	jmp    80105c3f <alltraps>

8010662b <vector116>:
.globl vector116
vector116:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $116
8010662d:	6a 74                	push   $0x74
  jmp alltraps
8010662f:	e9 0b f6 ff ff       	jmp    80105c3f <alltraps>

80106634 <vector117>:
.globl vector117
vector117:
  pushl $0
80106634:	6a 00                	push   $0x0
  pushl $117
80106636:	6a 75                	push   $0x75
  jmp alltraps
80106638:	e9 02 f6 ff ff       	jmp    80105c3f <alltraps>

8010663d <vector118>:
.globl vector118
vector118:
  pushl $0
8010663d:	6a 00                	push   $0x0
  pushl $118
8010663f:	6a 76                	push   $0x76
  jmp alltraps
80106641:	e9 f9 f5 ff ff       	jmp    80105c3f <alltraps>

80106646 <vector119>:
.globl vector119
vector119:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $119
80106648:	6a 77                	push   $0x77
  jmp alltraps
8010664a:	e9 f0 f5 ff ff       	jmp    80105c3f <alltraps>

8010664f <vector120>:
.globl vector120
vector120:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $120
80106651:	6a 78                	push   $0x78
  jmp alltraps
80106653:	e9 e7 f5 ff ff       	jmp    80105c3f <alltraps>

80106658 <vector121>:
.globl vector121
vector121:
  pushl $0
80106658:	6a 00                	push   $0x0
  pushl $121
8010665a:	6a 79                	push   $0x79
  jmp alltraps
8010665c:	e9 de f5 ff ff       	jmp    80105c3f <alltraps>

80106661 <vector122>:
.globl vector122
vector122:
  pushl $0
80106661:	6a 00                	push   $0x0
  pushl $122
80106663:	6a 7a                	push   $0x7a
  jmp alltraps
80106665:	e9 d5 f5 ff ff       	jmp    80105c3f <alltraps>

8010666a <vector123>:
.globl vector123
vector123:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $123
8010666c:	6a 7b                	push   $0x7b
  jmp alltraps
8010666e:	e9 cc f5 ff ff       	jmp    80105c3f <alltraps>

80106673 <vector124>:
.globl vector124
vector124:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $124
80106675:	6a 7c                	push   $0x7c
  jmp alltraps
80106677:	e9 c3 f5 ff ff       	jmp    80105c3f <alltraps>

8010667c <vector125>:
.globl vector125
vector125:
  pushl $0
8010667c:	6a 00                	push   $0x0
  pushl $125
8010667e:	6a 7d                	push   $0x7d
  jmp alltraps
80106680:	e9 ba f5 ff ff       	jmp    80105c3f <alltraps>

80106685 <vector126>:
.globl vector126
vector126:
  pushl $0
80106685:	6a 00                	push   $0x0
  pushl $126
80106687:	6a 7e                	push   $0x7e
  jmp alltraps
80106689:	e9 b1 f5 ff ff       	jmp    80105c3f <alltraps>

8010668e <vector127>:
.globl vector127
vector127:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $127
80106690:	6a 7f                	push   $0x7f
  jmp alltraps
80106692:	e9 a8 f5 ff ff       	jmp    80105c3f <alltraps>

80106697 <vector128>:
.globl vector128
vector128:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $128
80106699:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010669e:	e9 9c f5 ff ff       	jmp    80105c3f <alltraps>

801066a3 <vector129>:
.globl vector129
vector129:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $129
801066a5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801066aa:	e9 90 f5 ff ff       	jmp    80105c3f <alltraps>

801066af <vector130>:
.globl vector130
vector130:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $130
801066b1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801066b6:	e9 84 f5 ff ff       	jmp    80105c3f <alltraps>

801066bb <vector131>:
.globl vector131
vector131:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $131
801066bd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801066c2:	e9 78 f5 ff ff       	jmp    80105c3f <alltraps>

801066c7 <vector132>:
.globl vector132
vector132:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $132
801066c9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801066ce:	e9 6c f5 ff ff       	jmp    80105c3f <alltraps>

801066d3 <vector133>:
.globl vector133
vector133:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $133
801066d5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801066da:	e9 60 f5 ff ff       	jmp    80105c3f <alltraps>

801066df <vector134>:
.globl vector134
vector134:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $134
801066e1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801066e6:	e9 54 f5 ff ff       	jmp    80105c3f <alltraps>

801066eb <vector135>:
.globl vector135
vector135:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $135
801066ed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801066f2:	e9 48 f5 ff ff       	jmp    80105c3f <alltraps>

801066f7 <vector136>:
.globl vector136
vector136:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $136
801066f9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801066fe:	e9 3c f5 ff ff       	jmp    80105c3f <alltraps>

80106703 <vector137>:
.globl vector137
vector137:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $137
80106705:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010670a:	e9 30 f5 ff ff       	jmp    80105c3f <alltraps>

8010670f <vector138>:
.globl vector138
vector138:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $138
80106711:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106716:	e9 24 f5 ff ff       	jmp    80105c3f <alltraps>

8010671b <vector139>:
.globl vector139
vector139:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $139
8010671d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106722:	e9 18 f5 ff ff       	jmp    80105c3f <alltraps>

80106727 <vector140>:
.globl vector140
vector140:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $140
80106729:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010672e:	e9 0c f5 ff ff       	jmp    80105c3f <alltraps>

80106733 <vector141>:
.globl vector141
vector141:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $141
80106735:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010673a:	e9 00 f5 ff ff       	jmp    80105c3f <alltraps>

8010673f <vector142>:
.globl vector142
vector142:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $142
80106741:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106746:	e9 f4 f4 ff ff       	jmp    80105c3f <alltraps>

8010674b <vector143>:
.globl vector143
vector143:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $143
8010674d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106752:	e9 e8 f4 ff ff       	jmp    80105c3f <alltraps>

80106757 <vector144>:
.globl vector144
vector144:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $144
80106759:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010675e:	e9 dc f4 ff ff       	jmp    80105c3f <alltraps>

80106763 <vector145>:
.globl vector145
vector145:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $145
80106765:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010676a:	e9 d0 f4 ff ff       	jmp    80105c3f <alltraps>

8010676f <vector146>:
.globl vector146
vector146:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $146
80106771:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106776:	e9 c4 f4 ff ff       	jmp    80105c3f <alltraps>

8010677b <vector147>:
.globl vector147
vector147:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $147
8010677d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106782:	e9 b8 f4 ff ff       	jmp    80105c3f <alltraps>

80106787 <vector148>:
.globl vector148
vector148:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $148
80106789:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010678e:	e9 ac f4 ff ff       	jmp    80105c3f <alltraps>

80106793 <vector149>:
.globl vector149
vector149:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $149
80106795:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010679a:	e9 a0 f4 ff ff       	jmp    80105c3f <alltraps>

8010679f <vector150>:
.globl vector150
vector150:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $150
801067a1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801067a6:	e9 94 f4 ff ff       	jmp    80105c3f <alltraps>

801067ab <vector151>:
.globl vector151
vector151:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $151
801067ad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801067b2:	e9 88 f4 ff ff       	jmp    80105c3f <alltraps>

801067b7 <vector152>:
.globl vector152
vector152:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $152
801067b9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801067be:	e9 7c f4 ff ff       	jmp    80105c3f <alltraps>

801067c3 <vector153>:
.globl vector153
vector153:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $153
801067c5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801067ca:	e9 70 f4 ff ff       	jmp    80105c3f <alltraps>

801067cf <vector154>:
.globl vector154
vector154:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $154
801067d1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801067d6:	e9 64 f4 ff ff       	jmp    80105c3f <alltraps>

801067db <vector155>:
.globl vector155
vector155:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $155
801067dd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801067e2:	e9 58 f4 ff ff       	jmp    80105c3f <alltraps>

801067e7 <vector156>:
.globl vector156
vector156:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $156
801067e9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801067ee:	e9 4c f4 ff ff       	jmp    80105c3f <alltraps>

801067f3 <vector157>:
.globl vector157
vector157:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $157
801067f5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801067fa:	e9 40 f4 ff ff       	jmp    80105c3f <alltraps>

801067ff <vector158>:
.globl vector158
vector158:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $158
80106801:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106806:	e9 34 f4 ff ff       	jmp    80105c3f <alltraps>

8010680b <vector159>:
.globl vector159
vector159:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $159
8010680d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106812:	e9 28 f4 ff ff       	jmp    80105c3f <alltraps>

80106817 <vector160>:
.globl vector160
vector160:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $160
80106819:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010681e:	e9 1c f4 ff ff       	jmp    80105c3f <alltraps>

80106823 <vector161>:
.globl vector161
vector161:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $161
80106825:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010682a:	e9 10 f4 ff ff       	jmp    80105c3f <alltraps>

8010682f <vector162>:
.globl vector162
vector162:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $162
80106831:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106836:	e9 04 f4 ff ff       	jmp    80105c3f <alltraps>

8010683b <vector163>:
.globl vector163
vector163:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $163
8010683d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106842:	e9 f8 f3 ff ff       	jmp    80105c3f <alltraps>

80106847 <vector164>:
.globl vector164
vector164:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $164
80106849:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010684e:	e9 ec f3 ff ff       	jmp    80105c3f <alltraps>

80106853 <vector165>:
.globl vector165
vector165:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $165
80106855:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010685a:	e9 e0 f3 ff ff       	jmp    80105c3f <alltraps>

8010685f <vector166>:
.globl vector166
vector166:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $166
80106861:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106866:	e9 d4 f3 ff ff       	jmp    80105c3f <alltraps>

8010686b <vector167>:
.globl vector167
vector167:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $167
8010686d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106872:	e9 c8 f3 ff ff       	jmp    80105c3f <alltraps>

80106877 <vector168>:
.globl vector168
vector168:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $168
80106879:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010687e:	e9 bc f3 ff ff       	jmp    80105c3f <alltraps>

80106883 <vector169>:
.globl vector169
vector169:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $169
80106885:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010688a:	e9 b0 f3 ff ff       	jmp    80105c3f <alltraps>

8010688f <vector170>:
.globl vector170
vector170:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $170
80106891:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106896:	e9 a4 f3 ff ff       	jmp    80105c3f <alltraps>

8010689b <vector171>:
.globl vector171
vector171:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $171
8010689d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801068a2:	e9 98 f3 ff ff       	jmp    80105c3f <alltraps>

801068a7 <vector172>:
.globl vector172
vector172:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $172
801068a9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801068ae:	e9 8c f3 ff ff       	jmp    80105c3f <alltraps>

801068b3 <vector173>:
.globl vector173
vector173:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $173
801068b5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801068ba:	e9 80 f3 ff ff       	jmp    80105c3f <alltraps>

801068bf <vector174>:
.globl vector174
vector174:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $174
801068c1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801068c6:	e9 74 f3 ff ff       	jmp    80105c3f <alltraps>

801068cb <vector175>:
.globl vector175
vector175:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $175
801068cd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801068d2:	e9 68 f3 ff ff       	jmp    80105c3f <alltraps>

801068d7 <vector176>:
.globl vector176
vector176:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $176
801068d9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801068de:	e9 5c f3 ff ff       	jmp    80105c3f <alltraps>

801068e3 <vector177>:
.globl vector177
vector177:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $177
801068e5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801068ea:	e9 50 f3 ff ff       	jmp    80105c3f <alltraps>

801068ef <vector178>:
.globl vector178
vector178:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $178
801068f1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801068f6:	e9 44 f3 ff ff       	jmp    80105c3f <alltraps>

801068fb <vector179>:
.globl vector179
vector179:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $179
801068fd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106902:	e9 38 f3 ff ff       	jmp    80105c3f <alltraps>

80106907 <vector180>:
.globl vector180
vector180:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $180
80106909:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010690e:	e9 2c f3 ff ff       	jmp    80105c3f <alltraps>

80106913 <vector181>:
.globl vector181
vector181:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $181
80106915:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010691a:	e9 20 f3 ff ff       	jmp    80105c3f <alltraps>

8010691f <vector182>:
.globl vector182
vector182:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $182
80106921:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106926:	e9 14 f3 ff ff       	jmp    80105c3f <alltraps>

8010692b <vector183>:
.globl vector183
vector183:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $183
8010692d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106932:	e9 08 f3 ff ff       	jmp    80105c3f <alltraps>

80106937 <vector184>:
.globl vector184
vector184:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $184
80106939:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010693e:	e9 fc f2 ff ff       	jmp    80105c3f <alltraps>

80106943 <vector185>:
.globl vector185
vector185:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $185
80106945:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010694a:	e9 f0 f2 ff ff       	jmp    80105c3f <alltraps>

8010694f <vector186>:
.globl vector186
vector186:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $186
80106951:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106956:	e9 e4 f2 ff ff       	jmp    80105c3f <alltraps>

8010695b <vector187>:
.globl vector187
vector187:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $187
8010695d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106962:	e9 d8 f2 ff ff       	jmp    80105c3f <alltraps>

80106967 <vector188>:
.globl vector188
vector188:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $188
80106969:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010696e:	e9 cc f2 ff ff       	jmp    80105c3f <alltraps>

80106973 <vector189>:
.globl vector189
vector189:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $189
80106975:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010697a:	e9 c0 f2 ff ff       	jmp    80105c3f <alltraps>

8010697f <vector190>:
.globl vector190
vector190:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $190
80106981:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106986:	e9 b4 f2 ff ff       	jmp    80105c3f <alltraps>

8010698b <vector191>:
.globl vector191
vector191:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $191
8010698d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106992:	e9 a8 f2 ff ff       	jmp    80105c3f <alltraps>

80106997 <vector192>:
.globl vector192
vector192:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $192
80106999:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010699e:	e9 9c f2 ff ff       	jmp    80105c3f <alltraps>

801069a3 <vector193>:
.globl vector193
vector193:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $193
801069a5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801069aa:	e9 90 f2 ff ff       	jmp    80105c3f <alltraps>

801069af <vector194>:
.globl vector194
vector194:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $194
801069b1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801069b6:	e9 84 f2 ff ff       	jmp    80105c3f <alltraps>

801069bb <vector195>:
.globl vector195
vector195:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $195
801069bd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801069c2:	e9 78 f2 ff ff       	jmp    80105c3f <alltraps>

801069c7 <vector196>:
.globl vector196
vector196:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $196
801069c9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801069ce:	e9 6c f2 ff ff       	jmp    80105c3f <alltraps>

801069d3 <vector197>:
.globl vector197
vector197:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $197
801069d5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801069da:	e9 60 f2 ff ff       	jmp    80105c3f <alltraps>

801069df <vector198>:
.globl vector198
vector198:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $198
801069e1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801069e6:	e9 54 f2 ff ff       	jmp    80105c3f <alltraps>

801069eb <vector199>:
.globl vector199
vector199:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $199
801069ed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801069f2:	e9 48 f2 ff ff       	jmp    80105c3f <alltraps>

801069f7 <vector200>:
.globl vector200
vector200:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $200
801069f9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801069fe:	e9 3c f2 ff ff       	jmp    80105c3f <alltraps>

80106a03 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $201
80106a05:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a0a:	e9 30 f2 ff ff       	jmp    80105c3f <alltraps>

80106a0f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $202
80106a11:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a16:	e9 24 f2 ff ff       	jmp    80105c3f <alltraps>

80106a1b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $203
80106a1d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a22:	e9 18 f2 ff ff       	jmp    80105c3f <alltraps>

80106a27 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $204
80106a29:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a2e:	e9 0c f2 ff ff       	jmp    80105c3f <alltraps>

80106a33 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $205
80106a35:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a3a:	e9 00 f2 ff ff       	jmp    80105c3f <alltraps>

80106a3f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $206
80106a41:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a46:	e9 f4 f1 ff ff       	jmp    80105c3f <alltraps>

80106a4b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $207
80106a4d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a52:	e9 e8 f1 ff ff       	jmp    80105c3f <alltraps>

80106a57 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $208
80106a59:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a5e:	e9 dc f1 ff ff       	jmp    80105c3f <alltraps>

80106a63 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $209
80106a65:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a6a:	e9 d0 f1 ff ff       	jmp    80105c3f <alltraps>

80106a6f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $210
80106a71:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a76:	e9 c4 f1 ff ff       	jmp    80105c3f <alltraps>

80106a7b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $211
80106a7d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a82:	e9 b8 f1 ff ff       	jmp    80105c3f <alltraps>

80106a87 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $212
80106a89:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a8e:	e9 ac f1 ff ff       	jmp    80105c3f <alltraps>

80106a93 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $213
80106a95:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a9a:	e9 a0 f1 ff ff       	jmp    80105c3f <alltraps>

80106a9f <vector214>:
.globl vector214
vector214:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $214
80106aa1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106aa6:	e9 94 f1 ff ff       	jmp    80105c3f <alltraps>

80106aab <vector215>:
.globl vector215
vector215:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $215
80106aad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106ab2:	e9 88 f1 ff ff       	jmp    80105c3f <alltraps>

80106ab7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $216
80106ab9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106abe:	e9 7c f1 ff ff       	jmp    80105c3f <alltraps>

80106ac3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $217
80106ac5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106aca:	e9 70 f1 ff ff       	jmp    80105c3f <alltraps>

80106acf <vector218>:
.globl vector218
vector218:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $218
80106ad1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ad6:	e9 64 f1 ff ff       	jmp    80105c3f <alltraps>

80106adb <vector219>:
.globl vector219
vector219:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $219
80106add:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ae2:	e9 58 f1 ff ff       	jmp    80105c3f <alltraps>

80106ae7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $220
80106ae9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106aee:	e9 4c f1 ff ff       	jmp    80105c3f <alltraps>

80106af3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $221
80106af5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106afa:	e9 40 f1 ff ff       	jmp    80105c3f <alltraps>

80106aff <vector222>:
.globl vector222
vector222:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $222
80106b01:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b06:	e9 34 f1 ff ff       	jmp    80105c3f <alltraps>

80106b0b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $223
80106b0d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b12:	e9 28 f1 ff ff       	jmp    80105c3f <alltraps>

80106b17 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $224
80106b19:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b1e:	e9 1c f1 ff ff       	jmp    80105c3f <alltraps>

80106b23 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $225
80106b25:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b2a:	e9 10 f1 ff ff       	jmp    80105c3f <alltraps>

80106b2f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $226
80106b31:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b36:	e9 04 f1 ff ff       	jmp    80105c3f <alltraps>

80106b3b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $227
80106b3d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b42:	e9 f8 f0 ff ff       	jmp    80105c3f <alltraps>

80106b47 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $228
80106b49:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b4e:	e9 ec f0 ff ff       	jmp    80105c3f <alltraps>

80106b53 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $229
80106b55:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b5a:	e9 e0 f0 ff ff       	jmp    80105c3f <alltraps>

80106b5f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $230
80106b61:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b66:	e9 d4 f0 ff ff       	jmp    80105c3f <alltraps>

80106b6b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $231
80106b6d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b72:	e9 c8 f0 ff ff       	jmp    80105c3f <alltraps>

80106b77 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $232
80106b79:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b7e:	e9 bc f0 ff ff       	jmp    80105c3f <alltraps>

80106b83 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $233
80106b85:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b8a:	e9 b0 f0 ff ff       	jmp    80105c3f <alltraps>

80106b8f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $234
80106b91:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b96:	e9 a4 f0 ff ff       	jmp    80105c3f <alltraps>

80106b9b <vector235>:
.globl vector235
vector235:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $235
80106b9d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ba2:	e9 98 f0 ff ff       	jmp    80105c3f <alltraps>

80106ba7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $236
80106ba9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106bae:	e9 8c f0 ff ff       	jmp    80105c3f <alltraps>

80106bb3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $237
80106bb5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106bba:	e9 80 f0 ff ff       	jmp    80105c3f <alltraps>

80106bbf <vector238>:
.globl vector238
vector238:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $238
80106bc1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106bc6:	e9 74 f0 ff ff       	jmp    80105c3f <alltraps>

80106bcb <vector239>:
.globl vector239
vector239:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $239
80106bcd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106bd2:	e9 68 f0 ff ff       	jmp    80105c3f <alltraps>

80106bd7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $240
80106bd9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106bde:	e9 5c f0 ff ff       	jmp    80105c3f <alltraps>

80106be3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $241
80106be5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106bea:	e9 50 f0 ff ff       	jmp    80105c3f <alltraps>

80106bef <vector242>:
.globl vector242
vector242:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $242
80106bf1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106bf6:	e9 44 f0 ff ff       	jmp    80105c3f <alltraps>

80106bfb <vector243>:
.globl vector243
vector243:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $243
80106bfd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c02:	e9 38 f0 ff ff       	jmp    80105c3f <alltraps>

80106c07 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $244
80106c09:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c0e:	e9 2c f0 ff ff       	jmp    80105c3f <alltraps>

80106c13 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $245
80106c15:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c1a:	e9 20 f0 ff ff       	jmp    80105c3f <alltraps>

80106c1f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $246
80106c21:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c26:	e9 14 f0 ff ff       	jmp    80105c3f <alltraps>

80106c2b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $247
80106c2d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c32:	e9 08 f0 ff ff       	jmp    80105c3f <alltraps>

80106c37 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $248
80106c39:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c3e:	e9 fc ef ff ff       	jmp    80105c3f <alltraps>

80106c43 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $249
80106c45:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c4a:	e9 f0 ef ff ff       	jmp    80105c3f <alltraps>

80106c4f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $250
80106c51:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c56:	e9 e4 ef ff ff       	jmp    80105c3f <alltraps>

80106c5b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $251
80106c5d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c62:	e9 d8 ef ff ff       	jmp    80105c3f <alltraps>

80106c67 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $252
80106c69:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c6e:	e9 cc ef ff ff       	jmp    80105c3f <alltraps>

80106c73 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $253
80106c75:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c7a:	e9 c0 ef ff ff       	jmp    80105c3f <alltraps>

80106c7f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $254
80106c81:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c86:	e9 b4 ef ff ff       	jmp    80105c3f <alltraps>

80106c8b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $255
80106c8d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c92:	e9 a8 ef ff ff       	jmp    80105c3f <alltraps>
80106c97:	66 90                	xchg   %ax,%ax
80106c99:	66 90                	xchg   %ax,%ax
80106c9b:	66 90                	xchg   %ax,%ax
80106c9d:	66 90                	xchg   %ax,%ax
80106c9f:	90                   	nop

80106ca0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	57                   	push   %edi
80106ca4:	56                   	push   %esi
80106ca5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ca6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106cac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cb2:	83 ec 1c             	sub    $0x1c,%esp
80106cb5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106cb8:	39 d3                	cmp    %edx,%ebx
80106cba:	73 49                	jae    80106d05 <deallocuvm.part.0+0x65>
80106cbc:	89 c7                	mov    %eax,%edi
80106cbe:	eb 0c                	jmp    80106ccc <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106cc0:	83 c0 01             	add    $0x1,%eax
80106cc3:	c1 e0 16             	shl    $0x16,%eax
80106cc6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106cc8:	39 da                	cmp    %ebx,%edx
80106cca:	76 39                	jbe    80106d05 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106ccc:	89 d8                	mov    %ebx,%eax
80106cce:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106cd1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106cd4:	f6 c1 01             	test   $0x1,%cl
80106cd7:	74 e7                	je     80106cc0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106cd9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cdb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106ce1:	c1 ee 0a             	shr    $0xa,%esi
80106ce4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106cea:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106cf1:	85 f6                	test   %esi,%esi
80106cf3:	74 cb                	je     80106cc0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106cf5:	8b 06                	mov    (%esi),%eax
80106cf7:	a8 01                	test   $0x1,%al
80106cf9:	75 15                	jne    80106d10 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106cfb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d01:	39 da                	cmp    %ebx,%edx
80106d03:	77 c7                	ja     80106ccc <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d05:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d0b:	5b                   	pop    %ebx
80106d0c:	5e                   	pop    %esi
80106d0d:	5f                   	pop    %edi
80106d0e:	5d                   	pop    %ebp
80106d0f:	c3                   	ret    
      if(pa == 0)
80106d10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d15:	74 25                	je     80106d3c <deallocuvm.part.0+0x9c>
      kfree(v);
80106d17:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d1a:	05 00 00 00 80       	add    $0x80000000,%eax
80106d1f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d22:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106d28:	50                   	push   %eax
80106d29:	e8 92 b7 ff ff       	call   801024c0 <kfree>
      *pte = 0;
80106d2e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106d34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106d37:	83 c4 10             	add    $0x10,%esp
80106d3a:	eb 8c                	jmp    80106cc8 <deallocuvm.part.0+0x28>
        panic("kfree");
80106d3c:	83 ec 0c             	sub    $0xc,%esp
80106d3f:	68 86 7a 10 80       	push   $0x80107a86
80106d44:	e8 37 96 ff ff       	call   80100380 <panic>
80106d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d50 <mappages>:
{
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	57                   	push   %edi
80106d54:	56                   	push   %esi
80106d55:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106d56:	89 d3                	mov    %edx,%ebx
80106d58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106d5e:	83 ec 1c             	sub    $0x1c,%esp
80106d61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d64:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d70:	8b 45 08             	mov    0x8(%ebp),%eax
80106d73:	29 d8                	sub    %ebx,%eax
80106d75:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d78:	eb 3d                	jmp    80106db7 <mappages+0x67>
80106d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106d80:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106d87:	c1 ea 0a             	shr    $0xa,%edx
80106d8a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d90:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d97:	85 c0                	test   %eax,%eax
80106d99:	74 75                	je     80106e10 <mappages+0xc0>
    if(*pte & PTE_P)
80106d9b:	f6 00 01             	testb  $0x1,(%eax)
80106d9e:	0f 85 86 00 00 00    	jne    80106e2a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106da4:	0b 75 0c             	or     0xc(%ebp),%esi
80106da7:	83 ce 01             	or     $0x1,%esi
80106daa:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106dac:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106daf:	74 6f                	je     80106e20 <mappages+0xd0>
    a += PGSIZE;
80106db1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106db7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106dba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106dbd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106dc0:	89 d8                	mov    %ebx,%eax
80106dc2:	c1 e8 16             	shr    $0x16,%eax
80106dc5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106dc8:	8b 07                	mov    (%edi),%eax
80106dca:	a8 01                	test   $0x1,%al
80106dcc:	75 b2                	jne    80106d80 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106dce:	e8 dd b8 ff ff       	call   801026b0 <kalloc>
80106dd3:	85 c0                	test   %eax,%eax
80106dd5:	74 39                	je     80106e10 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106dd7:	83 ec 04             	sub    $0x4,%esp
80106dda:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106ddd:	68 00 10 00 00       	push   $0x1000
80106de2:	6a 00                	push   $0x0
80106de4:	50                   	push   %eax
80106de5:	e8 76 db ff ff       	call   80104960 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106dea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106ded:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106df0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106df6:	83 c8 07             	or     $0x7,%eax
80106df9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106dfb:	89 d8                	mov    %ebx,%eax
80106dfd:	c1 e8 0a             	shr    $0xa,%eax
80106e00:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e05:	01 d0                	add    %edx,%eax
80106e07:	eb 92                	jmp    80106d9b <mappages+0x4b>
80106e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e18:	5b                   	pop    %ebx
80106e19:	5e                   	pop    %esi
80106e1a:	5f                   	pop    %edi
80106e1b:	5d                   	pop    %ebp
80106e1c:	c3                   	ret    
80106e1d:	8d 76 00             	lea    0x0(%esi),%esi
80106e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e23:	31 c0                	xor    %eax,%eax
}
80106e25:	5b                   	pop    %ebx
80106e26:	5e                   	pop    %esi
80106e27:	5f                   	pop    %edi
80106e28:	5d                   	pop    %ebp
80106e29:	c3                   	ret    
      panic("remap");
80106e2a:	83 ec 0c             	sub    $0xc,%esp
80106e2d:	68 a8 82 10 80       	push   $0x801082a8
80106e32:	e8 49 95 ff ff       	call   80100380 <panic>
80106e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e3e:	66 90                	xchg   %ax,%ax

80106e40 <seginit>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e46:	e8 65 cc ff ff       	call   80103ab0 <cpuid>
  pd[0] = size-1;
80106e4b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106e50:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106e56:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e5a:	c7 80 18 a8 14 80 ff 	movl   $0xffff,-0x7feb57e8(%eax)
80106e61:	ff 00 00 
80106e64:	c7 80 1c a8 14 80 00 	movl   $0xcf9a00,-0x7feb57e4(%eax)
80106e6b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e6e:	c7 80 20 a8 14 80 ff 	movl   $0xffff,-0x7feb57e0(%eax)
80106e75:	ff 00 00 
80106e78:	c7 80 24 a8 14 80 00 	movl   $0xcf9200,-0x7feb57dc(%eax)
80106e7f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e82:	c7 80 28 a8 14 80 ff 	movl   $0xffff,-0x7feb57d8(%eax)
80106e89:	ff 00 00 
80106e8c:	c7 80 2c a8 14 80 00 	movl   $0xcffa00,-0x7feb57d4(%eax)
80106e93:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e96:	c7 80 30 a8 14 80 ff 	movl   $0xffff,-0x7feb57d0(%eax)
80106e9d:	ff 00 00 
80106ea0:	c7 80 34 a8 14 80 00 	movl   $0xcff200,-0x7feb57cc(%eax)
80106ea7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106eaa:	05 10 a8 14 80       	add    $0x8014a810,%eax
  pd[1] = (uint)p;
80106eaf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106eb3:	c1 e8 10             	shr    $0x10,%eax
80106eb6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106eba:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ebd:	0f 01 10             	lgdtl  (%eax)
}
80106ec0:	c9                   	leave  
80106ec1:	c3                   	ret    
80106ec2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ed0 <walkpgdir>:
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	57                   	push   %edi
80106ed4:	56                   	push   %esi
80106ed5:	53                   	push   %ebx
80106ed6:	83 ec 0c             	sub    $0xc,%esp
80106ed9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde = &pgdir[PDX(va)];
80106edc:	8b 55 08             	mov    0x8(%ebp),%edx
80106edf:	89 fe                	mov    %edi,%esi
80106ee1:	c1 ee 16             	shr    $0x16,%esi
80106ee4:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
80106ee7:	8b 1e                	mov    (%esi),%ebx
80106ee9:	f6 c3 01             	test   $0x1,%bl
80106eec:	74 22                	je     80106f10 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106eee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106ef4:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  return &pgtab[PTX(va)];
80106efa:	89 f8                	mov    %edi,%eax
}
80106efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106eff:	c1 e8 0a             	shr    $0xa,%eax
80106f02:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f07:	01 d8                	add    %ebx,%eax
}
80106f09:	5b                   	pop    %ebx
80106f0a:	5e                   	pop    %esi
80106f0b:	5f                   	pop    %edi
80106f0c:	5d                   	pop    %ebp
80106f0d:	c3                   	ret    
80106f0e:	66 90                	xchg   %ax,%ax
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106f10:	8b 45 10             	mov    0x10(%ebp),%eax
80106f13:	85 c0                	test   %eax,%eax
80106f15:	74 31                	je     80106f48 <walkpgdir+0x78>
80106f17:	e8 94 b7 ff ff       	call   801026b0 <kalloc>
80106f1c:	89 c3                	mov    %eax,%ebx
80106f1e:	85 c0                	test   %eax,%eax
80106f20:	74 26                	je     80106f48 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
80106f22:	83 ec 04             	sub    $0x4,%esp
80106f25:	68 00 10 00 00       	push   $0x1000
80106f2a:	6a 00                	push   $0x0
80106f2c:	50                   	push   %eax
80106f2d:	e8 2e da ff ff       	call   80104960 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106f32:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f38:	83 c4 10             	add    $0x10,%esp
80106f3b:	83 c8 07             	or     $0x7,%eax
80106f3e:	89 06                	mov    %eax,(%esi)
80106f40:	eb b8                	jmp    80106efa <walkpgdir+0x2a>
80106f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80106f48:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106f4b:	31 c0                	xor    %eax,%eax
}
80106f4d:	5b                   	pop    %ebx
80106f4e:	5e                   	pop    %esi
80106f4f:	5f                   	pop    %edi
80106f50:	5d                   	pop    %ebp
80106f51:	c3                   	ret    
80106f52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f60 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f60:	a1 c4 d4 14 80       	mov    0x8014d4c4,%eax
80106f65:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f6a:	0f 22 d8             	mov    %eax,%cr3
}
80106f6d:	c3                   	ret    
80106f6e:	66 90                	xchg   %ax,%ax

80106f70 <switchuvm>:
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	57                   	push   %edi
80106f74:	56                   	push   %esi
80106f75:	53                   	push   %ebx
80106f76:	83 ec 1c             	sub    $0x1c,%esp
80106f79:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106f7c:	85 f6                	test   %esi,%esi
80106f7e:	0f 84 cb 00 00 00    	je     8010704f <switchuvm+0xdf>
  if(p->kstack == 0)
80106f84:	8b 46 08             	mov    0x8(%esi),%eax
80106f87:	85 c0                	test   %eax,%eax
80106f89:	0f 84 da 00 00 00    	je     80107069 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106f8f:	8b 46 04             	mov    0x4(%esi),%eax
80106f92:	85 c0                	test   %eax,%eax
80106f94:	0f 84 c2 00 00 00    	je     8010705c <switchuvm+0xec>
  pushcli();
80106f9a:	e8 b1 d7 ff ff       	call   80104750 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f9f:	e8 ac ca ff ff       	call   80103a50 <mycpu>
80106fa4:	89 c3                	mov    %eax,%ebx
80106fa6:	e8 a5 ca ff ff       	call   80103a50 <mycpu>
80106fab:	89 c7                	mov    %eax,%edi
80106fad:	e8 9e ca ff ff       	call   80103a50 <mycpu>
80106fb2:	83 c7 08             	add    $0x8,%edi
80106fb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fb8:	e8 93 ca ff ff       	call   80103a50 <mycpu>
80106fbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106fc0:	ba 67 00 00 00       	mov    $0x67,%edx
80106fc5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106fcc:	83 c0 08             	add    $0x8,%eax
80106fcf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fd6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fdb:	83 c1 08             	add    $0x8,%ecx
80106fde:	c1 e8 18             	shr    $0x18,%eax
80106fe1:	c1 e9 10             	shr    $0x10,%ecx
80106fe4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106fea:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106ff0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106ff5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ffc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107001:	e8 4a ca ff ff       	call   80103a50 <mycpu>
80107006:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010700d:	e8 3e ca ff ff       	call   80103a50 <mycpu>
80107012:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107016:	8b 5e 08             	mov    0x8(%esi),%ebx
80107019:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010701f:	e8 2c ca ff ff       	call   80103a50 <mycpu>
80107024:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107027:	e8 24 ca ff ff       	call   80103a50 <mycpu>
8010702c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107030:	b8 28 00 00 00       	mov    $0x28,%eax
80107035:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107038:	8b 46 04             	mov    0x4(%esi),%eax
8010703b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107040:	0f 22 d8             	mov    %eax,%cr3
}
80107043:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107046:	5b                   	pop    %ebx
80107047:	5e                   	pop    %esi
80107048:	5f                   	pop    %edi
80107049:	5d                   	pop    %ebp
  popcli();
8010704a:	e9 51 d7 ff ff       	jmp    801047a0 <popcli>
    panic("switchuvm: no process");
8010704f:	83 ec 0c             	sub    $0xc,%esp
80107052:	68 ae 82 10 80       	push   $0x801082ae
80107057:	e8 24 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010705c:	83 ec 0c             	sub    $0xc,%esp
8010705f:	68 d9 82 10 80       	push   $0x801082d9
80107064:	e8 17 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107069:	83 ec 0c             	sub    $0xc,%esp
8010706c:	68 c4 82 10 80       	push   $0x801082c4
80107071:	e8 0a 93 ff ff       	call   80100380 <panic>
80107076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010707d:	8d 76 00             	lea    0x0(%esi),%esi

80107080 <inituvm>:
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	57                   	push   %edi
80107084:	56                   	push   %esi
80107085:	53                   	push   %ebx
80107086:	83 ec 1c             	sub    $0x1c,%esp
80107089:	8b 45 0c             	mov    0xc(%ebp),%eax
8010708c:	8b 75 10             	mov    0x10(%ebp),%esi
8010708f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107092:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107095:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010709b:	77 4b                	ja     801070e8 <inituvm+0x68>
  mem = kalloc();
8010709d:	e8 0e b6 ff ff       	call   801026b0 <kalloc>
  memset(mem, 0, PGSIZE);
801070a2:	83 ec 04             	sub    $0x4,%esp
801070a5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801070aa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801070ac:	6a 00                	push   $0x0
801070ae:	50                   	push   %eax
801070af:	e8 ac d8 ff ff       	call   80104960 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801070b4:	58                   	pop    %eax
801070b5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070bb:	5a                   	pop    %edx
801070bc:	6a 06                	push   $0x6
801070be:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070c3:	31 d2                	xor    %edx,%edx
801070c5:	50                   	push   %eax
801070c6:	89 f8                	mov    %edi,%eax
801070c8:	e8 83 fc ff ff       	call   80106d50 <mappages>
  memmove(mem, init, sz);
801070cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070d0:	89 75 10             	mov    %esi,0x10(%ebp)
801070d3:	83 c4 10             	add    $0x10,%esp
801070d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801070d9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801070dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070df:	5b                   	pop    %ebx
801070e0:	5e                   	pop    %esi
801070e1:	5f                   	pop    %edi
801070e2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801070e3:	e9 18 d9 ff ff       	jmp    80104a00 <memmove>
    panic("inituvm: more than a page");
801070e8:	83 ec 0c             	sub    $0xc,%esp
801070eb:	68 ed 82 10 80       	push   $0x801082ed
801070f0:	e8 8b 92 ff ff       	call   80100380 <panic>
801070f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107100 <loaduvm>:
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	57                   	push   %edi
80107104:	56                   	push   %esi
80107105:	53                   	push   %ebx
80107106:	83 ec 1c             	sub    $0x1c,%esp
80107109:	8b 45 0c             	mov    0xc(%ebp),%eax
8010710c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010710f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107114:	0f 85 bb 00 00 00    	jne    801071d5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010711a:	01 f0                	add    %esi,%eax
8010711c:	89 f3                	mov    %esi,%ebx
8010711e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107121:	8b 45 14             	mov    0x14(%ebp),%eax
80107124:	01 f0                	add    %esi,%eax
80107126:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107129:	85 f6                	test   %esi,%esi
8010712b:	0f 84 87 00 00 00    	je     801071b8 <loaduvm+0xb8>
80107131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107138:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010713b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010713e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107140:	89 c2                	mov    %eax,%edx
80107142:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107145:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107148:	f6 c2 01             	test   $0x1,%dl
8010714b:	75 13                	jne    80107160 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010714d:	83 ec 0c             	sub    $0xc,%esp
80107150:	68 07 83 10 80       	push   $0x80108307
80107155:	e8 26 92 ff ff       	call   80100380 <panic>
8010715a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107160:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107163:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107169:	25 fc 0f 00 00       	and    $0xffc,%eax
8010716e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107175:	85 c0                	test   %eax,%eax
80107177:	74 d4                	je     8010714d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107179:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010717b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010717e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107183:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107188:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010718e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107191:	29 d9                	sub    %ebx,%ecx
80107193:	05 00 00 00 80       	add    $0x80000000,%eax
80107198:	57                   	push   %edi
80107199:	51                   	push   %ecx
8010719a:	50                   	push   %eax
8010719b:	ff 75 10             	push   0x10(%ebp)
8010719e:	e8 ed a8 ff ff       	call   80101a90 <readi>
801071a3:	83 c4 10             	add    $0x10,%esp
801071a6:	39 f8                	cmp    %edi,%eax
801071a8:	75 1e                	jne    801071c8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801071aa:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801071b0:	89 f0                	mov    %esi,%eax
801071b2:	29 d8                	sub    %ebx,%eax
801071b4:	39 c6                	cmp    %eax,%esi
801071b6:	77 80                	ja     80107138 <loaduvm+0x38>
}
801071b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071bb:	31 c0                	xor    %eax,%eax
}
801071bd:	5b                   	pop    %ebx
801071be:	5e                   	pop    %esi
801071bf:	5f                   	pop    %edi
801071c0:	5d                   	pop    %ebp
801071c1:	c3                   	ret    
801071c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071d0:	5b                   	pop    %ebx
801071d1:	5e                   	pop    %esi
801071d2:	5f                   	pop    %edi
801071d3:	5d                   	pop    %ebp
801071d4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801071d5:	83 ec 0c             	sub    $0xc,%esp
801071d8:	68 e4 83 10 80       	push   $0x801083e4
801071dd:	e8 9e 91 ff ff       	call   80100380 <panic>
801071e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071f0 <allocuvm>:
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	57                   	push   %edi
801071f4:	56                   	push   %esi
801071f5:	53                   	push   %ebx
801071f6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801071f9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801071fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801071ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107202:	85 c0                	test   %eax,%eax
80107204:	0f 88 b6 00 00 00    	js     801072c0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010720a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010720d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107210:	0f 82 9a 00 00 00    	jb     801072b0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107216:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010721c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107222:	39 75 10             	cmp    %esi,0x10(%ebp)
80107225:	77 44                	ja     8010726b <allocuvm+0x7b>
80107227:	e9 87 00 00 00       	jmp    801072b3 <allocuvm+0xc3>
8010722c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107230:	83 ec 04             	sub    $0x4,%esp
80107233:	68 00 10 00 00       	push   $0x1000
80107238:	6a 00                	push   $0x0
8010723a:	50                   	push   %eax
8010723b:	e8 20 d7 ff ff       	call   80104960 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107240:	58                   	pop    %eax
80107241:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107247:	5a                   	pop    %edx
80107248:	6a 06                	push   $0x6
8010724a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010724f:	89 f2                	mov    %esi,%edx
80107251:	50                   	push   %eax
80107252:	89 f8                	mov    %edi,%eax
80107254:	e8 f7 fa ff ff       	call   80106d50 <mappages>
80107259:	83 c4 10             	add    $0x10,%esp
8010725c:	85 c0                	test   %eax,%eax
8010725e:	78 78                	js     801072d8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107260:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107266:	39 75 10             	cmp    %esi,0x10(%ebp)
80107269:	76 48                	jbe    801072b3 <allocuvm+0xc3>
    mem = kalloc();
8010726b:	e8 40 b4 ff ff       	call   801026b0 <kalloc>
80107270:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107272:	85 c0                	test   %eax,%eax
80107274:	75 ba                	jne    80107230 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107276:	83 ec 0c             	sub    $0xc,%esp
80107279:	68 25 83 10 80       	push   $0x80108325
8010727e:	e8 1d 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107283:	8b 45 0c             	mov    0xc(%ebp),%eax
80107286:	83 c4 10             	add    $0x10,%esp
80107289:	39 45 10             	cmp    %eax,0x10(%ebp)
8010728c:	74 32                	je     801072c0 <allocuvm+0xd0>
8010728e:	8b 55 10             	mov    0x10(%ebp),%edx
80107291:	89 c1                	mov    %eax,%ecx
80107293:	89 f8                	mov    %edi,%eax
80107295:	e8 06 fa ff ff       	call   80106ca0 <deallocuvm.part.0>
      return 0;
8010729a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801072a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072a7:	5b                   	pop    %ebx
801072a8:	5e                   	pop    %esi
801072a9:	5f                   	pop    %edi
801072aa:	5d                   	pop    %ebp
801072ab:	c3                   	ret    
801072ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801072b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801072b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072b9:	5b                   	pop    %ebx
801072ba:	5e                   	pop    %esi
801072bb:	5f                   	pop    %edi
801072bc:	5d                   	pop    %ebp
801072bd:	c3                   	ret    
801072be:	66 90                	xchg   %ax,%ax
    return 0;
801072c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801072c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072cd:	5b                   	pop    %ebx
801072ce:	5e                   	pop    %esi
801072cf:	5f                   	pop    %edi
801072d0:	5d                   	pop    %ebp
801072d1:	c3                   	ret    
801072d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801072d8:	83 ec 0c             	sub    $0xc,%esp
801072db:	68 3d 83 10 80       	push   $0x8010833d
801072e0:	e8 bb 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801072e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801072e8:	83 c4 10             	add    $0x10,%esp
801072eb:	39 45 10             	cmp    %eax,0x10(%ebp)
801072ee:	74 0c                	je     801072fc <allocuvm+0x10c>
801072f0:	8b 55 10             	mov    0x10(%ebp),%edx
801072f3:	89 c1                	mov    %eax,%ecx
801072f5:	89 f8                	mov    %edi,%eax
801072f7:	e8 a4 f9 ff ff       	call   80106ca0 <deallocuvm.part.0>
      kfree(mem);
801072fc:	83 ec 0c             	sub    $0xc,%esp
801072ff:	53                   	push   %ebx
80107300:	e8 bb b1 ff ff       	call   801024c0 <kfree>
      return 0;
80107305:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010730c:	83 c4 10             	add    $0x10,%esp
}
8010730f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107312:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107315:	5b                   	pop    %ebx
80107316:	5e                   	pop    %esi
80107317:	5f                   	pop    %edi
80107318:	5d                   	pop    %ebp
80107319:	c3                   	ret    
8010731a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107320 <deallocuvm>:
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	8b 55 0c             	mov    0xc(%ebp),%edx
80107326:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107329:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010732c:	39 d1                	cmp    %edx,%ecx
8010732e:	73 10                	jae    80107340 <deallocuvm+0x20>
}
80107330:	5d                   	pop    %ebp
80107331:	e9 6a f9 ff ff       	jmp    80106ca0 <deallocuvm.part.0>
80107336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010733d:	8d 76 00             	lea    0x0(%esi),%esi
80107340:	89 d0                	mov    %edx,%eax
80107342:	5d                   	pop    %ebp
80107343:	c3                   	ret    
80107344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010734b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010734f:	90                   	nop

80107350 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107350:	55                   	push   %ebp
80107351:	89 e5                	mov    %esp,%ebp
80107353:	57                   	push   %edi
80107354:	56                   	push   %esi
80107355:	53                   	push   %ebx
80107356:	83 ec 0c             	sub    $0xc,%esp
80107359:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010735c:	85 f6                	test   %esi,%esi
8010735e:	74 59                	je     801073b9 <freevm+0x69>
  if(newsz >= oldsz)
80107360:	31 c9                	xor    %ecx,%ecx
80107362:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107367:	89 f0                	mov    %esi,%eax
80107369:	89 f3                	mov    %esi,%ebx
8010736b:	e8 30 f9 ff ff       	call   80106ca0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107370:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107376:	eb 0f                	jmp    80107387 <freevm+0x37>
80107378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010737f:	90                   	nop
80107380:	83 c3 04             	add    $0x4,%ebx
80107383:	39 df                	cmp    %ebx,%edi
80107385:	74 23                	je     801073aa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107387:	8b 03                	mov    (%ebx),%eax
80107389:	a8 01                	test   $0x1,%al
8010738b:	74 f3                	je     80107380 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010738d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107392:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107395:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107398:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010739d:	50                   	push   %eax
8010739e:	e8 1d b1 ff ff       	call   801024c0 <kfree>
801073a3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801073a6:	39 df                	cmp    %ebx,%edi
801073a8:	75 dd                	jne    80107387 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801073aa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801073ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073b0:	5b                   	pop    %ebx
801073b1:	5e                   	pop    %esi
801073b2:	5f                   	pop    %edi
801073b3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801073b4:	e9 07 b1 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
801073b9:	83 ec 0c             	sub    $0xc,%esp
801073bc:	68 59 83 10 80       	push   $0x80108359
801073c1:	e8 ba 8f ff ff       	call   80100380 <panic>
801073c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073cd:	8d 76 00             	lea    0x0(%esi),%esi

801073d0 <setupkvm>:
{
801073d0:	55                   	push   %ebp
801073d1:	89 e5                	mov    %esp,%ebp
801073d3:	56                   	push   %esi
801073d4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801073d5:	e8 d6 b2 ff ff       	call   801026b0 <kalloc>
801073da:	89 c6                	mov    %eax,%esi
801073dc:	85 c0                	test   %eax,%eax
801073de:	74 42                	je     80107422 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801073e0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073e3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801073e8:	68 00 10 00 00       	push   $0x1000
801073ed:	6a 00                	push   $0x0
801073ef:	50                   	push   %eax
801073f0:	e8 6b d5 ff ff       	call   80104960 <memset>
801073f5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801073f8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801073fb:	83 ec 08             	sub    $0x8,%esp
801073fe:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107401:	ff 73 0c             	push   0xc(%ebx)
80107404:	8b 13                	mov    (%ebx),%edx
80107406:	50                   	push   %eax
80107407:	29 c1                	sub    %eax,%ecx
80107409:	89 f0                	mov    %esi,%eax
8010740b:	e8 40 f9 ff ff       	call   80106d50 <mappages>
80107410:	83 c4 10             	add    $0x10,%esp
80107413:	85 c0                	test   %eax,%eax
80107415:	78 19                	js     80107430 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107417:	83 c3 10             	add    $0x10,%ebx
8010741a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107420:	75 d6                	jne    801073f8 <setupkvm+0x28>
}
80107422:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107425:	89 f0                	mov    %esi,%eax
80107427:	5b                   	pop    %ebx
80107428:	5e                   	pop    %esi
80107429:	5d                   	pop    %ebp
8010742a:	c3                   	ret    
8010742b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010742f:	90                   	nop
      freevm(pgdir);
80107430:	83 ec 0c             	sub    $0xc,%esp
80107433:	56                   	push   %esi
      return 0;
80107434:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107436:	e8 15 ff ff ff       	call   80107350 <freevm>
      return 0;
8010743b:	83 c4 10             	add    $0x10,%esp
}
8010743e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107441:	89 f0                	mov    %esi,%eax
80107443:	5b                   	pop    %ebx
80107444:	5e                   	pop    %esi
80107445:	5d                   	pop    %ebp
80107446:	c3                   	ret    
80107447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010744e:	66 90                	xchg   %ax,%ax

80107450 <kvmalloc>:
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107456:	e8 75 ff ff ff       	call   801073d0 <setupkvm>
8010745b:	a3 c4 d4 14 80       	mov    %eax,0x8014d4c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107460:	05 00 00 00 80       	add    $0x80000000,%eax
80107465:	0f 22 d8             	mov    %eax,%cr3
}
80107468:	c9                   	leave  
80107469:	c3                   	ret    
8010746a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107470 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107470:	55                   	push   %ebp
80107471:	89 e5                	mov    %esp,%ebp
80107473:	83 ec 08             	sub    $0x8,%esp
80107476:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107479:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010747c:	89 c1                	mov    %eax,%ecx
8010747e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107481:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107484:	f6 c2 01             	test   $0x1,%dl
80107487:	75 17                	jne    801074a0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107489:	83 ec 0c             	sub    $0xc,%esp
8010748c:	68 6a 83 10 80       	push   $0x8010836a
80107491:	e8 ea 8e ff ff       	call   80100380 <panic>
80107496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010749d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801074a0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074a3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801074a9:	25 fc 0f 00 00       	and    $0xffc,%eax
801074ae:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801074b5:	85 c0                	test   %eax,%eax
801074b7:	74 d0                	je     80107489 <clearpteu+0x19>
  *pte &= ~PTE_U;
801074b9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801074bc:	c9                   	leave  
801074bd:	c3                   	ret    
801074be:	66 90                	xchg   %ax,%ax

801074c0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801074c0:	55                   	push   %ebp
801074c1:	89 e5                	mov    %esp,%ebp
801074c3:	57                   	push   %edi
801074c4:	56                   	push   %esi
801074c5:	53                   	push   %ebx
801074c6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801074c9:	e8 02 ff ff ff       	call   801073d0 <setupkvm>
801074ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
801074d1:	85 c0                	test   %eax,%eax
801074d3:	0f 84 bd 00 00 00    	je     80107596 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801074d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074dc:	85 c9                	test   %ecx,%ecx
801074de:	0f 84 b2 00 00 00    	je     80107596 <copyuvm+0xd6>
801074e4:	31 f6                	xor    %esi,%esi
801074e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801074f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801074f3:	89 f0                	mov    %esi,%eax
801074f5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801074f8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801074fb:	a8 01                	test   $0x1,%al
801074fd:	75 11                	jne    80107510 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801074ff:	83 ec 0c             	sub    $0xc,%esp
80107502:	68 74 83 10 80       	push   $0x80108374
80107507:	e8 74 8e ff ff       	call   80100380 <panic>
8010750c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107510:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107512:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107517:	c1 ea 0a             	shr    $0xa,%edx
8010751a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107520:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107527:	85 c0                	test   %eax,%eax
80107529:	74 d4                	je     801074ff <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010752b:	8b 00                	mov    (%eax),%eax
8010752d:	a8 01                	test   $0x1,%al
8010752f:	0f 84 9f 00 00 00    	je     801075d4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107535:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107537:	25 ff 0f 00 00       	and    $0xfff,%eax
8010753c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010753f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107545:	e8 66 b1 ff ff       	call   801026b0 <kalloc>
8010754a:	89 c3                	mov    %eax,%ebx
8010754c:	85 c0                	test   %eax,%eax
8010754e:	74 64                	je     801075b4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107550:	83 ec 04             	sub    $0x4,%esp
80107553:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107559:	68 00 10 00 00       	push   $0x1000
8010755e:	57                   	push   %edi
8010755f:	50                   	push   %eax
80107560:	e8 9b d4 ff ff       	call   80104a00 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107565:	58                   	pop    %eax
80107566:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010756c:	5a                   	pop    %edx
8010756d:	ff 75 e4             	push   -0x1c(%ebp)
80107570:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107575:	89 f2                	mov    %esi,%edx
80107577:	50                   	push   %eax
80107578:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010757b:	e8 d0 f7 ff ff       	call   80106d50 <mappages>
80107580:	83 c4 10             	add    $0x10,%esp
80107583:	85 c0                	test   %eax,%eax
80107585:	78 21                	js     801075a8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107587:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010758d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107590:	0f 87 5a ff ff ff    	ja     801074f0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107596:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107599:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010759c:	5b                   	pop    %ebx
8010759d:	5e                   	pop    %esi
8010759e:	5f                   	pop    %edi
8010759f:	5d                   	pop    %ebp
801075a0:	c3                   	ret    
801075a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801075a8:	83 ec 0c             	sub    $0xc,%esp
801075ab:	53                   	push   %ebx
801075ac:	e8 0f af ff ff       	call   801024c0 <kfree>
      goto bad;
801075b1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801075b4:	83 ec 0c             	sub    $0xc,%esp
801075b7:	ff 75 e0             	push   -0x20(%ebp)
801075ba:	e8 91 fd ff ff       	call   80107350 <freevm>
  return 0;
801075bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801075c6:	83 c4 10             	add    $0x10,%esp
}
801075c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075cf:	5b                   	pop    %ebx
801075d0:	5e                   	pop    %esi
801075d1:	5f                   	pop    %edi
801075d2:	5d                   	pop    %ebp
801075d3:	c3                   	ret    
      panic("copyuvm: page not present");
801075d4:	83 ec 0c             	sub    $0xc,%esp
801075d7:	68 8e 83 10 80       	push   $0x8010838e
801075dc:	e8 9f 8d ff ff       	call   80100380 <panic>
801075e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ef:	90                   	nop

801075f0 <copyuvmcow>:

pde_t*
copyuvmcow(pde_t *pgdir, uint sz)
{
801075f0:	55                   	push   %ebp
801075f1:	89 e5                	mov    %esp,%ebp
801075f3:	57                   	push   %edi
801075f4:	56                   	push   %esi
801075f5:	53                   	push   %ebx
801075f6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
801075f9:	e8 d2 fd ff ff       	call   801073d0 <setupkvm>
801075fe:	89 c7                	mov    %eax,%edi
80107600:	85 c0                	test   %eax,%eax
80107602:	0f 84 ad 00 00 00    	je     801076b5 <copyuvmcow+0xc5>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107608:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010760b:	85 c9                	test   %ecx,%ecx
8010760d:	0f 84 a2 00 00 00    	je     801076b5 <copyuvmcow+0xc5>
80107613:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107616:	31 f6                	xor    %esi,%esi
80107618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010761f:	90                   	nop
  if(*pde & PTE_P){
80107620:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107623:	89 f0                	mov    %esi,%eax
80107625:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107628:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010762b:	a8 01                	test   $0x1,%al
8010762d:	75 11                	jne    80107640 <copyuvmcow+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvmcow: pte should exist");
8010762f:	83 ec 0c             	sub    $0xc,%esp
80107632:	68 a8 83 10 80       	push   $0x801083a8
80107637:	e8 44 8d ff ff       	call   80100380 <panic>
8010763c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107640:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107642:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107647:	c1 ea 0a             	shr    $0xa,%edx
8010764a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107650:	8d 94 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edx
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107657:	85 d2                	test   %edx,%edx
80107659:	74 d4                	je     8010762f <copyuvmcow+0x3f>
    if(!(*pte & PTE_P))
8010765b:	8b 1a                	mov    (%edx),%ebx
8010765d:	f6 c3 01             	test   $0x1,%bl
80107660:	74 79                	je     801076db <copyuvmcow+0xeb>
      panic("copyuvmcow: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    *pte &= ~PTE_W;
80107662:	89 d8                	mov    %ebx,%eax
    pa = PTE_ADDR(*pte);
80107664:	89 df                	mov    %ebx,%edi
    *pte |= PTE_COW;
    incr_ref_count((char *)P2V(pa));
80107666:	83 ec 0c             	sub    $0xc,%esp
    flags = PTE_FLAGS(*pte);
80107669:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    *pte &= ~PTE_W;
8010766f:	83 e0 fd             	and    $0xfffffffd,%eax
    pa = PTE_ADDR(*pte);
80107672:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    *pte |= PTE_COW;
80107678:	80 cc 02             	or     $0x2,%ah
8010767b:	89 02                	mov    %eax,(%edx)
    incr_ref_count((char *)P2V(pa));
8010767d:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107683:	50                   	push   %eax
80107684:	e8 87 b1 ff ff       	call   80102810 <incr_ref_count>
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) {
80107689:	58                   	pop    %eax
8010768a:	5a                   	pop    %edx
8010768b:	53                   	push   %ebx
8010768c:	57                   	push   %edi
8010768d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107690:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107695:	89 f2                	mov    %esi,%edx
80107697:	e8 b4 f6 ff ff       	call   80106d50 <mappages>
8010769c:	83 c4 10             	add    $0x10,%esp
8010769f:	85 c0                	test   %eax,%eax
801076a1:	78 1d                	js     801076c0 <copyuvmcow+0xd0>
  for(i = 0; i < sz; i += PGSIZE){
801076a3:	81 c6 00 10 00 00    	add    $0x1000,%esi
801076a9:	39 75 0c             	cmp    %esi,0xc(%ebp)
801076ac:	0f 87 6e ff ff ff    	ja     80107620 <copyuvmcow+0x30>
801076b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  return d;

bad:
  freevm(d);
  return 0;
}
801076b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076b8:	89 f8                	mov    %edi,%eax
801076ba:	5b                   	pop    %ebx
801076bb:	5e                   	pop    %esi
801076bc:	5f                   	pop    %edi
801076bd:	5d                   	pop    %ebp
801076be:	c3                   	ret    
801076bf:	90                   	nop
  freevm(d);
801076c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801076c3:	83 ec 0c             	sub    $0xc,%esp
801076c6:	57                   	push   %edi
  return 0;
801076c7:	31 ff                	xor    %edi,%edi
  freevm(d);
801076c9:	e8 82 fc ff ff       	call   80107350 <freevm>
  return 0;
801076ce:	83 c4 10             	add    $0x10,%esp
}
801076d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076d4:	89 f8                	mov    %edi,%eax
801076d6:	5b                   	pop    %ebx
801076d7:	5e                   	pop    %esi
801076d8:	5f                   	pop    %edi
801076d9:	5d                   	pop    %ebp
801076da:	c3                   	ret    
      panic("copyuvmcow: page not present");
801076db:	83 ec 0c             	sub    $0xc,%esp
801076de:	68 c5 83 10 80       	push   $0x801083c5
801076e3:	e8 98 8c ff ff       	call   80100380 <panic>
801076e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ef:	90                   	nop

801076f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801076f0:	55                   	push   %ebp
801076f1:	89 e5                	mov    %esp,%ebp
801076f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801076f6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801076f9:	89 c1                	mov    %eax,%ecx
801076fb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801076fe:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107701:	f6 c2 01             	test   $0x1,%dl
80107704:	0f 84 00 01 00 00    	je     8010780a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010770a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010770d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107713:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107714:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107719:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107720:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107722:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107727:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010772a:	05 00 00 00 80       	add    $0x80000000,%eax
8010772f:	83 fa 05             	cmp    $0x5,%edx
80107732:	ba 00 00 00 00       	mov    $0x0,%edx
80107737:	0f 45 c2             	cmovne %edx,%eax
}
8010773a:	c3                   	ret    
8010773b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010773f:	90                   	nop

80107740 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107740:	55                   	push   %ebp
80107741:	89 e5                	mov    %esp,%ebp
80107743:	57                   	push   %edi
80107744:	56                   	push   %esi
80107745:	53                   	push   %ebx
80107746:	83 ec 0c             	sub    $0xc,%esp
80107749:	8b 75 14             	mov    0x14(%ebp),%esi
8010774c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010774f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107752:	85 f6                	test   %esi,%esi
80107754:	75 51                	jne    801077a7 <copyout+0x67>
80107756:	e9 a5 00 00 00       	jmp    80107800 <copyout+0xc0>
8010775b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010775f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107760:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107766:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010776c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107772:	74 75                	je     801077e9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107774:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107776:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107779:	29 c3                	sub    %eax,%ebx
8010777b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107781:	39 f3                	cmp    %esi,%ebx
80107783:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107786:	29 f8                	sub    %edi,%eax
80107788:	83 ec 04             	sub    $0x4,%esp
8010778b:	01 c1                	add    %eax,%ecx
8010778d:	53                   	push   %ebx
8010778e:	52                   	push   %edx
8010778f:	51                   	push   %ecx
80107790:	e8 6b d2 ff ff       	call   80104a00 <memmove>
    len -= n;
    buf += n;
80107795:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107798:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010779e:	83 c4 10             	add    $0x10,%esp
    buf += n;
801077a1:	01 da                	add    %ebx,%edx
  while(len > 0){
801077a3:	29 de                	sub    %ebx,%esi
801077a5:	74 59                	je     80107800 <copyout+0xc0>
  if(*pde & PTE_P){
801077a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801077aa:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801077ac:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801077ae:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801077b1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801077b7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801077ba:	f6 c1 01             	test   $0x1,%cl
801077bd:	0f 84 4e 00 00 00    	je     80107811 <copyout.cold>
  return &pgtab[PTX(va)];
801077c3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077c5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801077cb:	c1 eb 0c             	shr    $0xc,%ebx
801077ce:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801077d4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801077db:	89 d9                	mov    %ebx,%ecx
801077dd:	83 e1 05             	and    $0x5,%ecx
801077e0:	83 f9 05             	cmp    $0x5,%ecx
801077e3:	0f 84 77 ff ff ff    	je     80107760 <copyout+0x20>
  }
  return 0;
}
801077e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801077ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801077f1:	5b                   	pop    %ebx
801077f2:	5e                   	pop    %esi
801077f3:	5f                   	pop    %edi
801077f4:	5d                   	pop    %ebp
801077f5:	c3                   	ret    
801077f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077fd:	8d 76 00             	lea    0x0(%esi),%esi
80107800:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107803:	31 c0                	xor    %eax,%eax
}
80107805:	5b                   	pop    %ebx
80107806:	5e                   	pop    %esi
80107807:	5f                   	pop    %edi
80107808:	5d                   	pop    %ebp
80107809:	c3                   	ret    

8010780a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010780a:	a1 00 00 00 00       	mov    0x0,%eax
8010780f:	0f 0b                	ud2    

80107811 <copyout.cold>:
80107811:	a1 00 00 00 00       	mov    0x0,%eax
80107816:	0f 0b                	ud2    
