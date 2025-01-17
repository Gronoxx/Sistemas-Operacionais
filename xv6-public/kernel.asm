
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
8010002d:	b8 20 31 10 80       	mov    $0x80103120,%eax
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
8010004c:	68 c0 77 10 80       	push   $0x801077c0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 55 45 00 00       	call   801045b0 <initlock>
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
80100092:	68 c7 77 10 80       	push   $0x801077c7
80100097:	50                   	push   %eax
80100098:	e8 e3 43 00 00       	call   80104480 <initsleeplock>
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
801000e4:	e8 97 46 00 00       	call   80104780 <acquire>
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
80100162:	e8 b9 45 00 00       	call   80104720 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 43 00 00       	call   801044c0 <acquiresleep>
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
801001a1:	68 ce 77 10 80       	push   $0x801077ce
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
801001be:	e8 9d 43 00 00       	call   80104560 <holdingsleep>
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
801001dc:	68 df 77 10 80       	push   $0x801077df
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
801001ff:	e8 5c 43 00 00       	call   80104560 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 0c 43 00 00       	call   80104520 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 60 45 00 00       	call   80104780 <acquire>
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
8010026c:	e9 af 44 00 00       	jmp    80104720 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 e6 77 10 80       	push   $0x801077e6
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
801002a0:	e8 db 44 00 00       	call   80104780 <acquire>
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
801002cd:	e8 4e 3f 00 00       	call   80104220 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 49 37 00 00       	call   80103a30 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 25 44 00 00       	call   80104720 <release>
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
8010034c:	e8 cf 43 00 00       	call   80104720 <release>
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
80100399:	e8 12 26 00 00       	call   801029b0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ed 77 10 80       	push   $0x801077ed
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 b3 81 10 80 	movl   $0x801081b3,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 03 42 00 00       	call   801045d0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 01 78 10 80       	push   $0x80107801
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
8010041a:	e8 b1 5c 00 00       	call   801060d0 <uartputc>
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
80100505:	e8 c6 5b 00 00       	call   801060d0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 ba 5b 00 00       	call   801060d0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 ae 5b 00 00       	call   801060d0 <uartputc>
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
80100551:	e8 8a 43 00 00       	call   801048e0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 d5 42 00 00       	call   80104840 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 05 78 10 80       	push   $0x80107805
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
801005ab:	e8 d0 41 00 00       	call   80104780 <acquire>
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
801005e4:	e8 37 41 00 00       	call   80104720 <release>
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
80100636:	0f b6 92 30 78 10 80 	movzbl -0x7fef87d0(%edx),%edx
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
801007e8:	e8 93 3f 00 00       	call   80104780 <acquire>
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
80100838:	bf 18 78 10 80       	mov    $0x80107818,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 c0 3e 00 00       	call   80104720 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 1f 78 10 80       	push   $0x8010781f
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
80100893:	e8 e8 3e 00 00       	call   80104780 <acquire>
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
801009d0:	e8 4b 3d 00 00       	call   80104720 <release>
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
80100a0e:	e9 ad 39 00 00       	jmp    801043c0 <procdump>
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
80100a44:	e8 97 38 00 00       	call   801042e0 <wakeup>
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
80100a66:	68 28 78 10 80       	push   $0x80107828
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 3b 3b 00 00       	call   801045b0 <initlock>

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
80100abc:	e8 6f 2f 00 00       	call   80103a30 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 54 23 00 00       	call   80102e20 <begin_op>

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
80100b0f:	e8 7c 23 00 00       	call   80102e90 <end_op>
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
80100b34:	e8 07 68 00 00       	call   80107340 <setupkvm>
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
80100ba3:	e8 a8 65 00 00       	call   80107150 <allocuvm>
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
80100bd9:	e8 82 64 00 00       	call   80107060 <loaduvm>
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
80100c1b:	e8 a0 66 00 00       	call   801072c0 <freevm>
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
80100c51:	e8 3a 22 00 00       	call   80102e90 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 e9 64 00 00       	call   80107150 <allocuvm>
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
80100c83:	e8 58 67 00 00       	call   801073e0 <clearpteu>
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
80100cd3:	e8 68 3d 00 00       	call   80104a40 <strlen>
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
80100ce7:	e8 54 3d 00 00       	call   80104a40 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 d3 69 00 00       	call   801076d0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 aa 65 00 00       	call   801072c0 <freevm>
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
80100d63:	e8 68 69 00 00       	call   801076d0 <copyout>
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
80100da1:	e8 5a 3c 00 00       	call   80104a00 <safestrcpy>
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
80100dcd:	e8 ee 60 00 00       	call   80106ec0 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 e6 64 00 00       	call   801072c0 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 a7 20 00 00       	call   80102e90 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 41 78 10 80       	push   $0x80107841
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
80100e16:	68 4d 78 10 80       	push   $0x8010784d
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 8b 37 00 00       	call   801045b0 <initlock>
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
80100e41:	e8 3a 39 00 00       	call   80104780 <acquire>
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
80100e71:	e8 aa 38 00 00       	call   80104720 <release>
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
80100e8a:	e8 91 38 00 00       	call   80104720 <release>
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
80100eaf:	e8 cc 38 00 00       	call   80104780 <acquire>
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
80100ecc:	e8 4f 38 00 00       	call   80104720 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 54 78 10 80       	push   $0x80107854
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
80100f01:	e8 7a 38 00 00       	call   80104780 <acquire>
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
80100f3c:	e8 df 37 00 00       	call   80104720 <release>

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
80100f6e:	e9 ad 37 00 00       	jmp    80104720 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 a3 1e 00 00       	call   80102e20 <begin_op>
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
80100f92:	e9 f9 1e 00 00       	jmp    80102e90 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 42 26 00 00       	call   801035f0 <pipeclose>
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
80100fbc:	68 5c 78 10 80       	push   $0x8010785c
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
8010108d:	e9 fe 26 00 00       	jmp    80103790 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 66 78 10 80       	push   $0x80107866
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
80101109:	e8 82 1d 00 00       	call   80102e90 <end_op>

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
8010112e:	e8 ed 1c 00 00       	call   80102e20 <begin_op>
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
80101165:	e8 26 1d 00 00       	call   80102e90 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 6f 78 10 80       	push   $0x8010786f
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
801011a9:	e9 e2 24 00 00       	jmp    80103690 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 75 78 10 80       	push   $0x80107875
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
8010120d:	e8 ee 1d 00 00       	call   80103000 <log_write>
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
80101227:	68 7f 78 10 80       	push   $0x8010787f
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
801012e4:	68 92 78 10 80       	push   $0x80107892
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
801012fd:	e8 fe 1c 00 00       	call   80103000 <log_write>
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
80101325:	e8 16 35 00 00       	call   80104840 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 ce 1c 00 00       	call   80103000 <log_write>
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
8010136a:	e8 11 34 00 00       	call   80104780 <acquire>
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
801013d7:	e8 44 33 00 00       	call   80104720 <release>

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
80101405:	e8 16 33 00 00       	call   80104720 <release>
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
80101438:	68 a8 78 10 80       	push   $0x801078a8
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
801014c5:	e8 36 1b 00 00       	call   80103000 <log_write>
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
80101515:	68 b8 78 10 80       	push   $0x801078b8
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
80101541:	e8 9a 33 00 00       	call   801048e0 <memmove>
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
8010156c:	68 cb 78 10 80       	push   $0x801078cb
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 35 30 00 00       	call   801045b0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 d2 78 10 80       	push   $0x801078d2
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 ec 2e 00 00       	call   80104480 <initsleeplock>
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
801015bc:	e8 1f 33 00 00       	call   801048e0 <memmove>
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
801015f3:	68 38 79 10 80       	push   $0x80107938
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
8010168e:	e8 ad 31 00 00       	call   80104840 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 5b 19 00 00       	call   80103000 <log_write>
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
801016c3:	68 d8 78 10 80       	push   $0x801078d8
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
80101731:	e8 aa 31 00 00       	call   801048e0 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 c2 18 00 00       	call   80103000 <log_write>
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
8010175f:	e8 1c 30 00 00       	call   80104780 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 ac 2f 00 00       	call   80104720 <release>
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
801017a2:	e8 19 2d 00 00       	call   801044c0 <acquiresleep>
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
80101818:	e8 c3 30 00 00       	call   801048e0 <memmove>
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
8010183d:	68 f0 78 10 80       	push   $0x801078f0
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 ea 78 10 80       	push   $0x801078ea
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
80101873:	e8 e8 2c 00 00       	call   80104560 <holdingsleep>
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
8010188f:	e9 8c 2c 00 00       	jmp    80104520 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 ff 78 10 80       	push   $0x801078ff
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
801018c0:	e8 fb 2b 00 00       	call   801044c0 <acquiresleep>
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
801018da:	e8 41 2c 00 00       	call   80104520 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 95 2e 00 00       	call   80104780 <acquire>
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
80101900:	e9 1b 2e 00 00       	jmp    80104720 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 6b 2e 00 00       	call   80104780 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 fc 2d 00 00       	call   80104720 <release>
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
80101a23:	e8 38 2b 00 00       	call   80104560 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 e1 2a 00 00       	call   80104520 <releasesleep>
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
80101a53:	68 ff 78 10 80       	push   $0x801078ff
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
80101b37:	e8 a4 2d 00 00       	call   801048e0 <memmove>
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
80101c33:	e8 a8 2c 00 00       	call   801048e0 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 c0 13 00 00       	call   80103000 <log_write>
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
80101cce:	e8 7d 2c 00 00       	call   80104950 <strncmp>
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
80101d2d:	e8 1e 2c 00 00       	call   80104950 <strncmp>
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
80101d72:	68 19 79 10 80       	push   $0x80107919
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 07 79 10 80       	push   $0x80107907
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
80101daa:	e8 81 1c 00 00       	call   80103a30 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 c1 29 00 00       	call   80104780 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 51 29 00 00       	call   80104720 <release>
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
80101e27:	e8 b4 2a 00 00       	call   801048e0 <memmove>
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
80101e8c:	e8 cf 26 00 00       	call   80104560 <holdingsleep>
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
80101eae:	e8 6d 26 00 00       	call   80104520 <releasesleep>
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
80101edb:	e8 00 2a 00 00       	call   801048e0 <memmove>
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
80101f2b:	e8 30 26 00 00       	call   80104560 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 d1 25 00 00       	call   80104520 <releasesleep>
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
80101f6d:	e8 ee 25 00 00       	call   80104560 <holdingsleep>
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
80101f90:	e8 cb 25 00 00       	call   80104560 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 74 25 00 00       	call   80104520 <releasesleep>
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
80101fcf:	68 ff 78 10 80       	push   $0x801078ff
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
8010203d:	e8 5e 29 00 00       	call   801049a0 <strncpy>
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
8010207b:	68 28 79 10 80       	push   $0x80107928
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 0e 7f 10 80       	push   $0x80107f0e
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
8010219b:	68 94 79 10 80       	push   $0x80107994
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 8b 79 10 80       	push   $0x8010798b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 a6 79 10 80       	push   $0x801079a6
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 db 23 00 00       	call   801045b0 <initlock>
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
8010224e:	e8 2d 25 00 00       	call   80104780 <acquire>

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
801022ad:	e8 2e 20 00 00       	call   801042e0 <wakeup>

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
801022cb:	e8 50 24 00 00       	call   80104720 <release>

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
801022ee:	e8 6d 22 00 00       	call   80104560 <holdingsleep>
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
80102328:	e8 53 24 00 00       	call   80104780 <acquire>

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
80102369:	e8 b2 1e 00 00       	call   80104220 <sleep>
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
80102386:	e9 95 23 00 00       	jmp    80104720 <release>
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
801023aa:	68 d5 79 10 80       	push   $0x801079d5
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 c0 79 10 80       	push   $0x801079c0
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 aa 79 10 80       	push   $0x801079aa
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
8010241a:	68 f4 79 10 80       	push   $0x801079f4
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
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb d0 e4 14 80    	cmp    $0x8014e4d0,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 49 23 00 00       	call   80104840 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 74 a6 14 80    	mov    0x8014a674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 78 a6 14 80       	mov    0x8014a678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 74 a6 14 80       	mov    0x8014a674,%eax
  kmem.freelist = r;
80102510:	89 1d 78 a6 14 80    	mov    %ebx,0x8014a678
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 40 a6 14 80       	push   $0x8014a640
80102528:	e8 53 22 00 00       	call   80104780 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 a6 14 80 	movl   $0x8014a640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 d8 21 00 00       	jmp    80104720 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 26 7a 10 80       	push   $0x80107a26
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 74 a6 14 80 01 	movl   $0x1,0x8014a674
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 2c 7a 10 80       	push   $0x80107a2c
80102620:	68 40 a6 14 80       	push   $0x8014a640
80102625:	e8 86 1f 00 00       	call   801045b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 a6 14 80 00 	movl   $0x0,0x8014a674
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 74 a6 14 80       	mov    0x8014a674,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 78 a6 14 80       	mov    0x8014a678,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 78 a6 14 80    	mov    %edx,0x8014a678
  if(kmem.use_lock)
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 40 a6 14 80       	push   $0x8014a640
801026b3:	e8 c8 20 00 00       	call   80104780 <acquire>
  r = kmem.freelist;
801026b8:	a1 78 a6 14 80       	mov    0x8014a678,%eax
  if(kmem.use_lock)
801026bd:	8b 15 74 a6 14 80    	mov    0x8014a674,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 78 a6 14 80    	mov    %ecx,0x8014a678
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 40 a6 14 80       	push   $0x8014a640
801026e1:	e8 3a 20 00 00       	call   80104720 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <get_ref_count>:


int get_ref_count(uint pa) {  
801026f0:	55                   	push   %ebp
801026f1:	89 e5                	mov    %esp,%ebp
801026f3:	8b 45 08             	mov    0x8(%ebp),%eax
  int index = pa / PGSIZE;
801026f6:	89 c2                	mov    %eax,%edx
801026f8:	c1 ea 0c             	shr    $0xc,%edx
  if (index < PHYSTOP / PGSIZE) {
801026fb:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102700:	77 0e                	ja     80102710 <get_ref_count+0x20>
    return ref_counts[index];
80102702:	8b 04 95 40 26 11 80 	mov    -0x7feed9c0(,%edx,4),%eax
  }
  return -1;  
}
80102709:	5d                   	pop    %ebp
8010270a:	c3                   	ret    
8010270b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010270f:	90                   	nop
  return -1;  
80102710:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102715:	5d                   	pop    %ebp
80102716:	c3                   	ret    
80102717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010271e:	66 90                	xchg   %ax,%ax

80102720 <incr_ref_count>:

void incr_ref_count(uint pa) {  
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	53                   	push   %ebx
80102724:	83 ec 10             	sub    $0x10,%esp
80102727:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&kmem.lock);
8010272a:	68 40 a6 14 80       	push   $0x8014a640
8010272f:	e8 4c 20 00 00       	call   80104780 <acquire>
  int index = pa / PGSIZE;  
80102734:	89 d8                	mov    %ebx,%eax
  if (index < PHYSTOP / PGSIZE) {
80102736:	83 c4 10             	add    $0x10,%esp
  int index = pa / PGSIZE;  
80102739:	c1 e8 0c             	shr    $0xc,%eax
  if (index < PHYSTOP / PGSIZE) {
8010273c:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102742:	77 08                	ja     8010274c <incr_ref_count+0x2c>
    ref_counts[index]++;
80102744:	83 04 85 40 26 11 80 	addl   $0x1,-0x7feed9c0(,%eax,4)
8010274b:	01 
  }
  release(&kmem.lock);
8010274c:	c7 45 08 40 a6 14 80 	movl   $0x8014a640,0x8(%ebp)
}
80102753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102756:	c9                   	leave  
  release(&kmem.lock);
80102757:	e9 c4 1f 00 00       	jmp    80104720 <release>
8010275c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102760 <decrement_ref_count>:

void decrement_ref_count(uint pa) {
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	53                   	push   %ebx
80102764:	83 ec 10             	sub    $0x10,%esp
80102767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&kmem.lock);  // Lock to ensure thread safety
8010276a:	68 40 a6 14 80       	push   $0x8014a640
8010276f:	e8 0c 20 00 00       	call   80104780 <acquire>

  int index = pa / PGSIZE;  // Get the index of the physical page
80102774:	89 d8                	mov    %ebx,%eax
    if (ref_counts[index] > 0) {
80102776:	83 c4 10             	add    $0x10,%esp
  int index = pa / PGSIZE;  // Get the index of the physical page
80102779:	c1 e8 0c             	shr    $0xc,%eax
    if (ref_counts[index] > 0) {
8010277c:	8b 14 85 40 26 11 80 	mov    -0x7feed9c0(,%eax,4),%edx
80102783:	85 d2                	test   %edx,%edx
80102785:	7e 0a                	jle    80102791 <decrement_ref_count+0x31>
      ref_counts[index]--;  // Decrease the reference count
80102787:	83 ea 01             	sub    $0x1,%edx
8010278a:	89 14 85 40 26 11 80 	mov    %edx,-0x7feed9c0(,%eax,4)
    } 

  release(&kmem.lock);  // Release the lock
80102791:	c7 45 08 40 a6 14 80 	movl   $0x8014a640,0x8(%ebp)
}
80102798:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010279b:	c9                   	leave  
  release(&kmem.lock);  // Release the lock
8010279c:	e9 7f 1f 00 00       	jmp    80104720 <release>
801027a1:	66 90                	xchg   %ax,%ax
801027a3:	66 90                	xchg   %ax,%ax
801027a5:	66 90                	xchg   %ax,%ax
801027a7:	66 90                	xchg   %ax,%ax
801027a9:	66 90                	xchg   %ax,%ax
801027ab:	66 90                	xchg   %ax,%ax
801027ad:	66 90                	xchg   %ax,%ax
801027af:	90                   	nop

801027b0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027b0:	ba 64 00 00 00       	mov    $0x64,%edx
801027b5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801027b6:	a8 01                	test   $0x1,%al
801027b8:	0f 84 c2 00 00 00    	je     80102880 <kbdgetc+0xd0>
{
801027be:	55                   	push   %ebp
801027bf:	ba 60 00 00 00       	mov    $0x60,%edx
801027c4:	89 e5                	mov    %esp,%ebp
801027c6:	53                   	push   %ebx
801027c7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801027c8:	8b 1d 7c a6 14 80    	mov    0x8014a67c,%ebx
  data = inb(KBDATAP);
801027ce:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801027d1:	3c e0                	cmp    $0xe0,%al
801027d3:	74 5b                	je     80102830 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801027d5:	89 da                	mov    %ebx,%edx
801027d7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801027da:	84 c0                	test   %al,%al
801027dc:	78 62                	js     80102840 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027de:	85 d2                	test   %edx,%edx
801027e0:	74 09                	je     801027eb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027e2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801027e5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801027e8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801027eb:	0f b6 91 60 7b 10 80 	movzbl -0x7fef84a0(%ecx),%edx
  shift ^= togglecode[data];
801027f2:	0f b6 81 60 7a 10 80 	movzbl -0x7fef85a0(%ecx),%eax
  shift |= shiftcode[data];
801027f9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801027fb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027fd:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801027ff:	89 15 7c a6 14 80    	mov    %edx,0x8014a67c
  c = charcode[shift & (CTL | SHIFT)][data];
80102805:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102808:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010280b:	8b 04 85 40 7a 10 80 	mov    -0x7fef85c0(,%eax,4),%eax
80102812:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102816:	74 0b                	je     80102823 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102818:	8d 50 9f             	lea    -0x61(%eax),%edx
8010281b:	83 fa 19             	cmp    $0x19,%edx
8010281e:	77 48                	ja     80102868 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102820:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102823:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102826:	c9                   	leave  
80102827:	c3                   	ret    
80102828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010282f:	90                   	nop
    shift |= E0ESC;
80102830:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102833:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102835:	89 1d 7c a6 14 80    	mov    %ebx,0x8014a67c
}
8010283b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010283e:	c9                   	leave  
8010283f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102840:	83 e0 7f             	and    $0x7f,%eax
80102843:	85 d2                	test   %edx,%edx
80102845:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102848:	0f b6 81 60 7b 10 80 	movzbl -0x7fef84a0(%ecx),%eax
8010284f:	83 c8 40             	or     $0x40,%eax
80102852:	0f b6 c0             	movzbl %al,%eax
80102855:	f7 d0                	not    %eax
80102857:	21 d8                	and    %ebx,%eax
}
80102859:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010285c:	a3 7c a6 14 80       	mov    %eax,0x8014a67c
    return 0;
80102861:	31 c0                	xor    %eax,%eax
}
80102863:	c9                   	leave  
80102864:	c3                   	ret    
80102865:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102868:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010286b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010286e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102871:	c9                   	leave  
      c += 'a' - 'A';
80102872:	83 f9 1a             	cmp    $0x1a,%ecx
80102875:	0f 42 c2             	cmovb  %edx,%eax
}
80102878:	c3                   	ret    
80102879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102880:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102885:	c3                   	ret    
80102886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010288d:	8d 76 00             	lea    0x0(%esi),%esi

80102890 <kbdintr>:

void
kbdintr(void)
{
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
80102893:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102896:	68 b0 27 10 80       	push   $0x801027b0
8010289b:	e8 e0 df ff ff       	call   80100880 <consoleintr>
}
801028a0:	83 c4 10             	add    $0x10,%esp
801028a3:	c9                   	leave  
801028a4:	c3                   	ret    
801028a5:	66 90                	xchg   %ax,%ax
801028a7:	66 90                	xchg   %ax,%ax
801028a9:	66 90                	xchg   %ax,%ax
801028ab:	66 90                	xchg   %ax,%ax
801028ad:	66 90                	xchg   %ax,%ax
801028af:	90                   	nop

801028b0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801028b0:	a1 80 a6 14 80       	mov    0x8014a680,%eax
801028b5:	85 c0                	test   %eax,%eax
801028b7:	0f 84 cb 00 00 00    	je     80102988 <lapicinit+0xd8>
  lapic[index] = value;
801028bd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801028c4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ca:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801028d1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801028de:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801028e1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801028eb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801028ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028f8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028fb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028fe:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102905:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102908:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010290b:	8b 50 30             	mov    0x30(%eax),%edx
8010290e:	c1 ea 10             	shr    $0x10,%edx
80102911:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102917:	75 77                	jne    80102990 <lapicinit+0xe0>
  lapic[index] = value;
80102919:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102920:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102923:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102926:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010292d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102930:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102933:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010293a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010293d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102940:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102947:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010294a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010294d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102954:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102957:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010295a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102961:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102964:	8b 50 20             	mov    0x20(%eax),%edx
80102967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010296e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102970:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102976:	80 e6 10             	and    $0x10,%dh
80102979:	75 f5                	jne    80102970 <lapicinit+0xc0>
  lapic[index] = value;
8010297b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102982:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102985:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102988:	c3                   	ret    
80102989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102990:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102997:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010299a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010299d:	e9 77 ff ff ff       	jmp    80102919 <lapicinit+0x69>
801029a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801029b0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801029b0:	a1 80 a6 14 80       	mov    0x8014a680,%eax
801029b5:	85 c0                	test   %eax,%eax
801029b7:	74 07                	je     801029c0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801029b9:	8b 40 20             	mov    0x20(%eax),%eax
801029bc:	c1 e8 18             	shr    $0x18,%eax
801029bf:	c3                   	ret    
    return 0;
801029c0:	31 c0                	xor    %eax,%eax
}
801029c2:	c3                   	ret    
801029c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801029d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801029d0:	a1 80 a6 14 80       	mov    0x8014a680,%eax
801029d5:	85 c0                	test   %eax,%eax
801029d7:	74 0d                	je     801029e6 <lapiceoi+0x16>
  lapic[index] = value;
801029d9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801029e6:	c3                   	ret    
801029e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ee:	66 90                	xchg   %ax,%ax

801029f0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801029f0:	c3                   	ret    
801029f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ff:	90                   	nop

80102a00 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a00:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a01:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a06:	ba 70 00 00 00       	mov    $0x70,%edx
80102a0b:	89 e5                	mov    %esp,%ebp
80102a0d:	53                   	push   %ebx
80102a0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a11:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a14:	ee                   	out    %al,(%dx)
80102a15:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a1a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a1f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a20:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a22:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a25:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a2b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a2d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102a30:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102a32:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a35:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a38:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a3e:	a1 80 a6 14 80       	mov    0x8014a680,%eax
80102a43:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a49:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a4c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a53:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a56:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a59:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a60:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a63:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a66:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a6c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a6f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a75:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a78:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a7e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a81:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a87:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a8d:	c9                   	leave  
80102a8e:	c3                   	ret    
80102a8f:	90                   	nop

80102a90 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a90:	55                   	push   %ebp
80102a91:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a96:	ba 70 00 00 00       	mov    $0x70,%edx
80102a9b:	89 e5                	mov    %esp,%ebp
80102a9d:	57                   	push   %edi
80102a9e:	56                   	push   %esi
80102a9f:	53                   	push   %ebx
80102aa0:	83 ec 4c             	sub    $0x4c,%esp
80102aa3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa4:	ba 71 00 00 00       	mov    $0x71,%edx
80102aa9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102aaa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aad:	bb 70 00 00 00       	mov    $0x70,%ebx
80102ab2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ab5:	8d 76 00             	lea    0x0(%esi),%esi
80102ab8:	31 c0                	xor    %eax,%eax
80102aba:	89 da                	mov    %ebx,%edx
80102abc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102ac2:	89 ca                	mov    %ecx,%edx
80102ac4:	ec                   	in     (%dx),%al
80102ac5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac8:	89 da                	mov    %ebx,%edx
80102aca:	b8 02 00 00 00       	mov    $0x2,%eax
80102acf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad6:	89 da                	mov    %ebx,%edx
80102ad8:	b8 04 00 00 00       	mov    $0x4,%eax
80102add:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ade:	89 ca                	mov    %ecx,%edx
80102ae0:	ec                   	in     (%dx),%al
80102ae1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae4:	89 da                	mov    %ebx,%edx
80102ae6:	b8 07 00 00 00       	mov    $0x7,%eax
80102aeb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aec:	89 ca                	mov    %ecx,%edx
80102aee:	ec                   	in     (%dx),%al
80102aef:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af2:	89 da                	mov    %ebx,%edx
80102af4:	b8 08 00 00 00       	mov    $0x8,%eax
80102af9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afa:	89 ca                	mov    %ecx,%edx
80102afc:	ec                   	in     (%dx),%al
80102afd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aff:	89 da                	mov    %ebx,%edx
80102b01:	b8 09 00 00 00       	mov    $0x9,%eax
80102b06:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b07:	89 ca                	mov    %ecx,%edx
80102b09:	ec                   	in     (%dx),%al
80102b0a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b0c:	89 da                	mov    %ebx,%edx
80102b0e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b14:	89 ca                	mov    %ecx,%edx
80102b16:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b17:	84 c0                	test   %al,%al
80102b19:	78 9d                	js     80102ab8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b1b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b1f:	89 fa                	mov    %edi,%edx
80102b21:	0f b6 fa             	movzbl %dl,%edi
80102b24:	89 f2                	mov    %esi,%edx
80102b26:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b29:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b2d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b30:	89 da                	mov    %ebx,%edx
80102b32:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102b35:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b38:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b3c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102b3f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b42:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b46:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b49:	31 c0                	xor    %eax,%eax
80102b4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4c:	89 ca                	mov    %ecx,%edx
80102b4e:	ec                   	in     (%dx),%al
80102b4f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b52:	89 da                	mov    %ebx,%edx
80102b54:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b57:	b8 02 00 00 00       	mov    $0x2,%eax
80102b5c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5d:	89 ca                	mov    %ecx,%edx
80102b5f:	ec                   	in     (%dx),%al
80102b60:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b63:	89 da                	mov    %ebx,%edx
80102b65:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b68:	b8 04 00 00 00       	mov    $0x4,%eax
80102b6d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6e:	89 ca                	mov    %ecx,%edx
80102b70:	ec                   	in     (%dx),%al
80102b71:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b74:	89 da                	mov    %ebx,%edx
80102b76:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b79:	b8 07 00 00 00       	mov    $0x7,%eax
80102b7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b7f:	89 ca                	mov    %ecx,%edx
80102b81:	ec                   	in     (%dx),%al
80102b82:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b85:	89 da                	mov    %ebx,%edx
80102b87:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b8a:	b8 08 00 00 00       	mov    $0x8,%eax
80102b8f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b90:	89 ca                	mov    %ecx,%edx
80102b92:	ec                   	in     (%dx),%al
80102b93:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b96:	89 da                	mov    %ebx,%edx
80102b98:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b9b:	b8 09 00 00 00       	mov    $0x9,%eax
80102ba0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ba1:	89 ca                	mov    %ecx,%edx
80102ba3:	ec                   	in     (%dx),%al
80102ba4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ba7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102baa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bad:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102bb0:	6a 18                	push   $0x18
80102bb2:	50                   	push   %eax
80102bb3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102bb6:	50                   	push   %eax
80102bb7:	e8 d4 1c 00 00       	call   80104890 <memcmp>
80102bbc:	83 c4 10             	add    $0x10,%esp
80102bbf:	85 c0                	test   %eax,%eax
80102bc1:	0f 85 f1 fe ff ff    	jne    80102ab8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102bc7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102bcb:	75 78                	jne    80102c45 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102bcd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bd0:	89 c2                	mov    %eax,%edx
80102bd2:	83 e0 0f             	and    $0xf,%eax
80102bd5:	c1 ea 04             	shr    $0x4,%edx
80102bd8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bdb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bde:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102be1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102be4:	89 c2                	mov    %eax,%edx
80102be6:	83 e0 0f             	and    $0xf,%eax
80102be9:	c1 ea 04             	shr    $0x4,%edx
80102bec:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bef:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bf2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102bf5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bf8:	89 c2                	mov    %eax,%edx
80102bfa:	83 e0 0f             	and    $0xf,%eax
80102bfd:	c1 ea 04             	shr    $0x4,%edx
80102c00:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c03:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c06:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c0c:	89 c2                	mov    %eax,%edx
80102c0e:	83 e0 0f             	and    $0xf,%eax
80102c11:	c1 ea 04             	shr    $0x4,%edx
80102c14:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c17:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c1a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c1d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c20:	89 c2                	mov    %eax,%edx
80102c22:	83 e0 0f             	and    $0xf,%eax
80102c25:	c1 ea 04             	shr    $0x4,%edx
80102c28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c2e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c31:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c34:	89 c2                	mov    %eax,%edx
80102c36:	83 e0 0f             	and    $0xf,%eax
80102c39:	c1 ea 04             	shr    $0x4,%edx
80102c3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c42:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c45:	8b 75 08             	mov    0x8(%ebp),%esi
80102c48:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c4b:	89 06                	mov    %eax,(%esi)
80102c4d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c50:	89 46 04             	mov    %eax,0x4(%esi)
80102c53:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c56:	89 46 08             	mov    %eax,0x8(%esi)
80102c59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c5c:	89 46 0c             	mov    %eax,0xc(%esi)
80102c5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c62:	89 46 10             	mov    %eax,0x10(%esi)
80102c65:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c68:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102c6b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102c72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c75:	5b                   	pop    %ebx
80102c76:	5e                   	pop    %esi
80102c77:	5f                   	pop    %edi
80102c78:	5d                   	pop    %ebp
80102c79:	c3                   	ret    
80102c7a:	66 90                	xchg   %ax,%ax
80102c7c:	66 90                	xchg   %ax,%ax
80102c7e:	66 90                	xchg   %ax,%ax

80102c80 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c80:	8b 0d e8 a6 14 80    	mov    0x8014a6e8,%ecx
80102c86:	85 c9                	test   %ecx,%ecx
80102c88:	0f 8e 8a 00 00 00    	jle    80102d18 <install_trans+0x98>
{
80102c8e:	55                   	push   %ebp
80102c8f:	89 e5                	mov    %esp,%ebp
80102c91:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c92:	31 ff                	xor    %edi,%edi
{
80102c94:	56                   	push   %esi
80102c95:	53                   	push   %ebx
80102c96:	83 ec 0c             	sub    $0xc,%esp
80102c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ca0:	a1 d4 a6 14 80       	mov    0x8014a6d4,%eax
80102ca5:	83 ec 08             	sub    $0x8,%esp
80102ca8:	01 f8                	add    %edi,%eax
80102caa:	83 c0 01             	add    $0x1,%eax
80102cad:	50                   	push   %eax
80102cae:	ff 35 e4 a6 14 80    	push   0x8014a6e4
80102cb4:	e8 17 d4 ff ff       	call   801000d0 <bread>
80102cb9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cbb:	58                   	pop    %eax
80102cbc:	5a                   	pop    %edx
80102cbd:	ff 34 bd ec a6 14 80 	push   -0x7feb5914(,%edi,4)
80102cc4:	ff 35 e4 a6 14 80    	push   0x8014a6e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cca:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ccd:	e8 fe d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cd2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cd5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cd7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cda:	68 00 02 00 00       	push   $0x200
80102cdf:	50                   	push   %eax
80102ce0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102ce3:	50                   	push   %eax
80102ce4:	e8 f7 1b 00 00       	call   801048e0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102ce9:	89 1c 24             	mov    %ebx,(%esp)
80102cec:	e8 bf d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102cf1:	89 34 24             	mov    %esi,(%esp)
80102cf4:	e8 f7 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102cf9:	89 1c 24             	mov    %ebx,(%esp)
80102cfc:	e8 ef d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d01:	83 c4 10             	add    $0x10,%esp
80102d04:	39 3d e8 a6 14 80    	cmp    %edi,0x8014a6e8
80102d0a:	7f 94                	jg     80102ca0 <install_trans+0x20>
  }
}
80102d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d0f:	5b                   	pop    %ebx
80102d10:	5e                   	pop    %esi
80102d11:	5f                   	pop    %edi
80102d12:	5d                   	pop    %ebp
80102d13:	c3                   	ret    
80102d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d18:	c3                   	ret    
80102d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d27:	ff 35 d4 a6 14 80    	push   0x8014a6d4
80102d2d:	ff 35 e4 a6 14 80    	push   0x8014a6e4
80102d33:	e8 98 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d38:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d3b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d3d:	a1 e8 a6 14 80       	mov    0x8014a6e8,%eax
80102d42:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d45:	85 c0                	test   %eax,%eax
80102d47:	7e 19                	jle    80102d62 <write_head+0x42>
80102d49:	31 d2                	xor    %edx,%edx
80102d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d4f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102d50:	8b 0c 95 ec a6 14 80 	mov    -0x7feb5914(,%edx,4),%ecx
80102d57:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d5b:	83 c2 01             	add    $0x1,%edx
80102d5e:	39 d0                	cmp    %edx,%eax
80102d60:	75 ee                	jne    80102d50 <write_head+0x30>
  }
  bwrite(buf);
80102d62:	83 ec 0c             	sub    $0xc,%esp
80102d65:	53                   	push   %ebx
80102d66:	e8 45 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d6b:	89 1c 24             	mov    %ebx,(%esp)
80102d6e:	e8 7d d4 ff ff       	call   801001f0 <brelse>
}
80102d73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d76:	83 c4 10             	add    $0x10,%esp
80102d79:	c9                   	leave  
80102d7a:	c3                   	ret    
80102d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d7f:	90                   	nop

80102d80 <initlog>:
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	53                   	push   %ebx
80102d84:	83 ec 2c             	sub    $0x2c,%esp
80102d87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d8a:	68 60 7c 10 80       	push   $0x80107c60
80102d8f:	68 a0 a6 14 80       	push   $0x8014a6a0
80102d94:	e8 17 18 00 00       	call   801045b0 <initlock>
  readsb(dev, &sb);
80102d99:	58                   	pop    %eax
80102d9a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d9d:	5a                   	pop    %edx
80102d9e:	50                   	push   %eax
80102d9f:	53                   	push   %ebx
80102da0:	e8 7b e7 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102da5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102da8:	59                   	pop    %ecx
  log.dev = dev;
80102da9:	89 1d e4 a6 14 80    	mov    %ebx,0x8014a6e4
  log.size = sb.nlog;
80102daf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102db2:	a3 d4 a6 14 80       	mov    %eax,0x8014a6d4
  log.size = sb.nlog;
80102db7:	89 15 d8 a6 14 80    	mov    %edx,0x8014a6d8
  struct buf *buf = bread(log.dev, log.start);
80102dbd:	5a                   	pop    %edx
80102dbe:	50                   	push   %eax
80102dbf:	53                   	push   %ebx
80102dc0:	e8 0b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102dc5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102dc8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102dcb:	89 1d e8 a6 14 80    	mov    %ebx,0x8014a6e8
  for (i = 0; i < log.lh.n; i++) {
80102dd1:	85 db                	test   %ebx,%ebx
80102dd3:	7e 1d                	jle    80102df2 <initlog+0x72>
80102dd5:	31 d2                	xor    %edx,%edx
80102dd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dde:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102de0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102de4:	89 0c 95 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102deb:	83 c2 01             	add    $0x1,%edx
80102dee:	39 d3                	cmp    %edx,%ebx
80102df0:	75 ee                	jne    80102de0 <initlog+0x60>
  brelse(buf);
80102df2:	83 ec 0c             	sub    $0xc,%esp
80102df5:	50                   	push   %eax
80102df6:	e8 f5 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102dfb:	e8 80 fe ff ff       	call   80102c80 <install_trans>
  log.lh.n = 0;
80102e00:	c7 05 e8 a6 14 80 00 	movl   $0x0,0x8014a6e8
80102e07:	00 00 00 
  write_head(); // clear the log
80102e0a:	e8 11 ff ff ff       	call   80102d20 <write_head>
}
80102e0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e12:	83 c4 10             	add    $0x10,%esp
80102e15:	c9                   	leave  
80102e16:	c3                   	ret    
80102e17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e1e:	66 90                	xchg   %ax,%ax

80102e20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e26:	68 a0 a6 14 80       	push   $0x8014a6a0
80102e2b:	e8 50 19 00 00       	call   80104780 <acquire>
80102e30:	83 c4 10             	add    $0x10,%esp
80102e33:	eb 18                	jmp    80102e4d <begin_op+0x2d>
80102e35:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e38:	83 ec 08             	sub    $0x8,%esp
80102e3b:	68 a0 a6 14 80       	push   $0x8014a6a0
80102e40:	68 a0 a6 14 80       	push   $0x8014a6a0
80102e45:	e8 d6 13 00 00       	call   80104220 <sleep>
80102e4a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e4d:	a1 e0 a6 14 80       	mov    0x8014a6e0,%eax
80102e52:	85 c0                	test   %eax,%eax
80102e54:	75 e2                	jne    80102e38 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e56:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
80102e5b:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
80102e61:	83 c0 01             	add    $0x1,%eax
80102e64:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e67:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e6a:	83 fa 1e             	cmp    $0x1e,%edx
80102e6d:	7f c9                	jg     80102e38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e6f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e72:	a3 dc a6 14 80       	mov    %eax,0x8014a6dc
      release(&log.lock);
80102e77:	68 a0 a6 14 80       	push   $0x8014a6a0
80102e7c:	e8 9f 18 00 00       	call   80104720 <release>
      break;
    }
  }
}
80102e81:	83 c4 10             	add    $0x10,%esp
80102e84:	c9                   	leave  
80102e85:	c3                   	ret    
80102e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e8d:	8d 76 00             	lea    0x0(%esi),%esi

80102e90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	57                   	push   %edi
80102e94:	56                   	push   %esi
80102e95:	53                   	push   %ebx
80102e96:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e99:	68 a0 a6 14 80       	push   $0x8014a6a0
80102e9e:	e8 dd 18 00 00       	call   80104780 <acquire>
  log.outstanding -= 1;
80102ea3:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
  if(log.committing)
80102ea8:	8b 35 e0 a6 14 80    	mov    0x8014a6e0,%esi
80102eae:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102eb1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102eb4:	89 1d dc a6 14 80    	mov    %ebx,0x8014a6dc
  if(log.committing)
80102eba:	85 f6                	test   %esi,%esi
80102ebc:	0f 85 22 01 00 00    	jne    80102fe4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102ec2:	85 db                	test   %ebx,%ebx
80102ec4:	0f 85 f6 00 00 00    	jne    80102fc0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102eca:	c7 05 e0 a6 14 80 01 	movl   $0x1,0x8014a6e0
80102ed1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ed4:	83 ec 0c             	sub    $0xc,%esp
80102ed7:	68 a0 a6 14 80       	push   $0x8014a6a0
80102edc:	e8 3f 18 00 00       	call   80104720 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ee1:	8b 0d e8 a6 14 80    	mov    0x8014a6e8,%ecx
80102ee7:	83 c4 10             	add    $0x10,%esp
80102eea:	85 c9                	test   %ecx,%ecx
80102eec:	7f 42                	jg     80102f30 <end_op+0xa0>
    acquire(&log.lock);
80102eee:	83 ec 0c             	sub    $0xc,%esp
80102ef1:	68 a0 a6 14 80       	push   $0x8014a6a0
80102ef6:	e8 85 18 00 00       	call   80104780 <acquire>
    wakeup(&log);
80102efb:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
    log.committing = 0;
80102f02:	c7 05 e0 a6 14 80 00 	movl   $0x0,0x8014a6e0
80102f09:	00 00 00 
    wakeup(&log);
80102f0c:	e8 cf 13 00 00       	call   801042e0 <wakeup>
    release(&log.lock);
80102f11:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
80102f18:	e8 03 18 00 00       	call   80104720 <release>
80102f1d:	83 c4 10             	add    $0x10,%esp
}
80102f20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f23:	5b                   	pop    %ebx
80102f24:	5e                   	pop    %esi
80102f25:	5f                   	pop    %edi
80102f26:	5d                   	pop    %ebp
80102f27:	c3                   	ret    
80102f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f2f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f30:	a1 d4 a6 14 80       	mov    0x8014a6d4,%eax
80102f35:	83 ec 08             	sub    $0x8,%esp
80102f38:	01 d8                	add    %ebx,%eax
80102f3a:	83 c0 01             	add    $0x1,%eax
80102f3d:	50                   	push   %eax
80102f3e:	ff 35 e4 a6 14 80    	push   0x8014a6e4
80102f44:	e8 87 d1 ff ff       	call   801000d0 <bread>
80102f49:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f4b:	58                   	pop    %eax
80102f4c:	5a                   	pop    %edx
80102f4d:	ff 34 9d ec a6 14 80 	push   -0x7feb5914(,%ebx,4)
80102f54:	ff 35 e4 a6 14 80    	push   0x8014a6e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f5a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f5d:	e8 6e d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f62:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f65:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f67:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f6a:	68 00 02 00 00       	push   $0x200
80102f6f:	50                   	push   %eax
80102f70:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f73:	50                   	push   %eax
80102f74:	e8 67 19 00 00       	call   801048e0 <memmove>
    bwrite(to);  // write the log
80102f79:	89 34 24             	mov    %esi,(%esp)
80102f7c:	e8 2f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f81:	89 3c 24             	mov    %edi,(%esp)
80102f84:	e8 67 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f89:	89 34 24             	mov    %esi,(%esp)
80102f8c:	e8 5f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f91:	83 c4 10             	add    $0x10,%esp
80102f94:	3b 1d e8 a6 14 80    	cmp    0x8014a6e8,%ebx
80102f9a:	7c 94                	jl     80102f30 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f9c:	e8 7f fd ff ff       	call   80102d20 <write_head>
    install_trans(); // Now install writes to home locations
80102fa1:	e8 da fc ff ff       	call   80102c80 <install_trans>
    log.lh.n = 0;
80102fa6:	c7 05 e8 a6 14 80 00 	movl   $0x0,0x8014a6e8
80102fad:	00 00 00 
    write_head();    // Erase the transaction from the log
80102fb0:	e8 6b fd ff ff       	call   80102d20 <write_head>
80102fb5:	e9 34 ff ff ff       	jmp    80102eee <end_op+0x5e>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102fc0:	83 ec 0c             	sub    $0xc,%esp
80102fc3:	68 a0 a6 14 80       	push   $0x8014a6a0
80102fc8:	e8 13 13 00 00       	call   801042e0 <wakeup>
  release(&log.lock);
80102fcd:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
80102fd4:	e8 47 17 00 00       	call   80104720 <release>
80102fd9:	83 c4 10             	add    $0x10,%esp
}
80102fdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fdf:	5b                   	pop    %ebx
80102fe0:	5e                   	pop    %esi
80102fe1:	5f                   	pop    %edi
80102fe2:	5d                   	pop    %ebp
80102fe3:	c3                   	ret    
    panic("log.committing");
80102fe4:	83 ec 0c             	sub    $0xc,%esp
80102fe7:	68 64 7c 10 80       	push   $0x80107c64
80102fec:	e8 8f d3 ff ff       	call   80100380 <panic>
80102ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ff8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fff:	90                   	nop

80103000 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103007:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
{
8010300d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103010:	83 fa 1d             	cmp    $0x1d,%edx
80103013:	0f 8f 85 00 00 00    	jg     8010309e <log_write+0x9e>
80103019:	a1 d8 a6 14 80       	mov    0x8014a6d8,%eax
8010301e:	83 e8 01             	sub    $0x1,%eax
80103021:	39 c2                	cmp    %eax,%edx
80103023:	7d 79                	jge    8010309e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103025:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
8010302a:	85 c0                	test   %eax,%eax
8010302c:	7e 7d                	jle    801030ab <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010302e:	83 ec 0c             	sub    $0xc,%esp
80103031:	68 a0 a6 14 80       	push   $0x8014a6a0
80103036:	e8 45 17 00 00       	call   80104780 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010303b:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
80103041:	83 c4 10             	add    $0x10,%esp
80103044:	85 d2                	test   %edx,%edx
80103046:	7e 4a                	jle    80103092 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103048:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010304b:	31 c0                	xor    %eax,%eax
8010304d:	eb 08                	jmp    80103057 <log_write+0x57>
8010304f:	90                   	nop
80103050:	83 c0 01             	add    $0x1,%eax
80103053:	39 c2                	cmp    %eax,%edx
80103055:	74 29                	je     80103080 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103057:	39 0c 85 ec a6 14 80 	cmp    %ecx,-0x7feb5914(,%eax,4)
8010305e:	75 f0                	jne    80103050 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103060:	89 0c 85 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103067:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010306a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010306d:	c7 45 08 a0 a6 14 80 	movl   $0x8014a6a0,0x8(%ebp)
}
80103074:	c9                   	leave  
  release(&log.lock);
80103075:	e9 a6 16 00 00       	jmp    80104720 <release>
8010307a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103080:	89 0c 95 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%edx,4)
    log.lh.n++;
80103087:	83 c2 01             	add    $0x1,%edx
8010308a:	89 15 e8 a6 14 80    	mov    %edx,0x8014a6e8
80103090:	eb d5                	jmp    80103067 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103092:	8b 43 08             	mov    0x8(%ebx),%eax
80103095:	a3 ec a6 14 80       	mov    %eax,0x8014a6ec
  if (i == log.lh.n)
8010309a:	75 cb                	jne    80103067 <log_write+0x67>
8010309c:	eb e9                	jmp    80103087 <log_write+0x87>
    panic("too big a transaction");
8010309e:	83 ec 0c             	sub    $0xc,%esp
801030a1:	68 73 7c 10 80       	push   $0x80107c73
801030a6:	e8 d5 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801030ab:	83 ec 0c             	sub    $0xc,%esp
801030ae:	68 89 7c 10 80       	push   $0x80107c89
801030b3:	e8 c8 d2 ff ff       	call   80100380 <panic>
801030b8:	66 90                	xchg   %ax,%ax
801030ba:	66 90                	xchg   %ax,%ax
801030bc:	66 90                	xchg   %ax,%ax
801030be:	66 90                	xchg   %ax,%ax

801030c0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	53                   	push   %ebx
801030c4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801030c7:	e8 44 09 00 00       	call   80103a10 <cpuid>
801030cc:	89 c3                	mov    %eax,%ebx
801030ce:	e8 3d 09 00 00       	call   80103a10 <cpuid>
801030d3:	83 ec 04             	sub    $0x4,%esp
801030d6:	53                   	push   %ebx
801030d7:	50                   	push   %eax
801030d8:	68 a4 7c 10 80       	push   $0x80107ca4
801030dd:	e8 be d5 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
801030e2:	e8 e9 2a 00 00       	call   80105bd0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801030e7:	e8 c4 08 00 00       	call   801039b0 <mycpu>
801030ec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801030ee:	b8 01 00 00 00       	mov    $0x1,%eax
801030f3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801030fa:	e8 11 0d 00 00       	call   80103e10 <scheduler>
801030ff:	90                   	nop

80103100 <mpenter>:
{
80103100:	55                   	push   %ebp
80103101:	89 e5                	mov    %esp,%ebp
80103103:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103106:	e8 a5 3d 00 00       	call   80106eb0 <switchkvm>
  seginit();
8010310b:	e8 80 3c 00 00       	call   80106d90 <seginit>
  lapicinit();
80103110:	e8 9b f7 ff ff       	call   801028b0 <lapicinit>
  mpmain();
80103115:	e8 a6 ff ff ff       	call   801030c0 <mpmain>
8010311a:	66 90                	xchg   %ax,%ax
8010311c:	66 90                	xchg   %ax,%ax
8010311e:	66 90                	xchg   %ax,%ax

80103120 <main>:
{
80103120:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103124:	83 e4 f0             	and    $0xfffffff0,%esp
80103127:	ff 71 fc             	push   -0x4(%ecx)
8010312a:	55                   	push   %ebp
8010312b:	89 e5                	mov    %esp,%ebp
8010312d:	53                   	push   %ebx
8010312e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010312f:	83 ec 08             	sub    $0x8,%esp
80103132:	68 00 00 40 80       	push   $0x80400000
80103137:	68 d0 e4 14 80       	push   $0x8014e4d0
8010313c:	e8 cf f4 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103141:	e8 7a 42 00 00       	call   801073c0 <kvmalloc>
  mpinit();        // detect other processors
80103146:	e8 85 01 00 00       	call   801032d0 <mpinit>
  lapicinit();     // interrupt controller
8010314b:	e8 60 f7 ff ff       	call   801028b0 <lapicinit>
  seginit();       // segment descriptors
80103150:	e8 3b 3c 00 00       	call   80106d90 <seginit>
  picinit();       // disable pic
80103155:	e8 76 03 00 00       	call   801034d0 <picinit>
  ioapicinit();    // another interrupt controller
8010315a:	e8 71 f2 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010315f:	e8 fc d8 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103164:	e8 87 2e 00 00       	call   80105ff0 <uartinit>
  pinit();         // process table
80103169:	e8 22 08 00 00       	call   80103990 <pinit>
  tvinit();        // trap vectors
8010316e:	e8 dd 29 00 00       	call   80105b50 <tvinit>
  binit();         // buffer cache
80103173:	e8 c8 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103178:	e8 93 dc ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
8010317d:	e8 3e f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103182:	83 c4 0c             	add    $0xc,%esp
80103185:	68 8a 00 00 00       	push   $0x8a
8010318a:	68 8c b4 10 80       	push   $0x8010b48c
8010318f:	68 00 70 00 80       	push   $0x80007000
80103194:	e8 47 17 00 00       	call   801048e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103199:	83 c4 10             	add    $0x10,%esp
8010319c:	69 05 84 a7 14 80 b0 	imul   $0xb0,0x8014a784,%eax
801031a3:	00 00 00 
801031a6:	05 a0 a7 14 80       	add    $0x8014a7a0,%eax
801031ab:	3d a0 a7 14 80       	cmp    $0x8014a7a0,%eax
801031b0:	76 7e                	jbe    80103230 <main+0x110>
801031b2:	bb a0 a7 14 80       	mov    $0x8014a7a0,%ebx
801031b7:	eb 20                	jmp    801031d9 <main+0xb9>
801031b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031c0:	69 05 84 a7 14 80 b0 	imul   $0xb0,0x8014a784,%eax
801031c7:	00 00 00 
801031ca:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801031d0:	05 a0 a7 14 80       	add    $0x8014a7a0,%eax
801031d5:	39 c3                	cmp    %eax,%ebx
801031d7:	73 57                	jae    80103230 <main+0x110>
    if(c == mycpu())  // We've started already.
801031d9:	e8 d2 07 00 00       	call   801039b0 <mycpu>
801031de:	39 c3                	cmp    %eax,%ebx
801031e0:	74 de                	je     801031c0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801031e2:	e8 99 f4 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801031e7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801031ea:	c7 05 f8 6f 00 80 00 	movl   $0x80103100,0x80006ff8
801031f1:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031f4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801031fb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801031fe:	05 00 10 00 00       	add    $0x1000,%eax
80103203:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103208:	0f b6 03             	movzbl (%ebx),%eax
8010320b:	68 00 70 00 00       	push   $0x7000
80103210:	50                   	push   %eax
80103211:	e8 ea f7 ff ff       	call   80102a00 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103216:	83 c4 10             	add    $0x10,%esp
80103219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103220:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103226:	85 c0                	test   %eax,%eax
80103228:	74 f6                	je     80103220 <main+0x100>
8010322a:	eb 94                	jmp    801031c0 <main+0xa0>
8010322c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103230:	83 ec 08             	sub    $0x8,%esp
80103233:	68 00 00 00 8e       	push   $0x8e000000
80103238:	68 00 00 40 80       	push   $0x80400000
8010323d:	e8 6e f3 ff ff       	call   801025b0 <kinit2>
  userinit();      // first user process
80103242:	e8 19 08 00 00       	call   80103a60 <userinit>
  mpmain();        // finish this processor's setup
80103247:	e8 74 fe ff ff       	call   801030c0 <mpmain>
8010324c:	66 90                	xchg   %ax,%ax
8010324e:	66 90                	xchg   %ax,%ax

80103250 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	57                   	push   %edi
80103254:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103255:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010325b:	53                   	push   %ebx
  e = addr+len;
8010325c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010325f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103262:	39 de                	cmp    %ebx,%esi
80103264:	72 10                	jb     80103276 <mpsearch1+0x26>
80103266:	eb 50                	jmp    801032b8 <mpsearch1+0x68>
80103268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010326f:	90                   	nop
80103270:	89 fe                	mov    %edi,%esi
80103272:	39 fb                	cmp    %edi,%ebx
80103274:	76 42                	jbe    801032b8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103276:	83 ec 04             	sub    $0x4,%esp
80103279:	8d 7e 10             	lea    0x10(%esi),%edi
8010327c:	6a 04                	push   $0x4
8010327e:	68 b8 7c 10 80       	push   $0x80107cb8
80103283:	56                   	push   %esi
80103284:	e8 07 16 00 00       	call   80104890 <memcmp>
80103289:	83 c4 10             	add    $0x10,%esp
8010328c:	85 c0                	test   %eax,%eax
8010328e:	75 e0                	jne    80103270 <mpsearch1+0x20>
80103290:	89 f2                	mov    %esi,%edx
80103292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103298:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010329b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010329e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801032a0:	39 fa                	cmp    %edi,%edx
801032a2:	75 f4                	jne    80103298 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032a4:	84 c0                	test   %al,%al
801032a6:	75 c8                	jne    80103270 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801032a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032ab:	89 f0                	mov    %esi,%eax
801032ad:	5b                   	pop    %ebx
801032ae:	5e                   	pop    %esi
801032af:	5f                   	pop    %edi
801032b0:	5d                   	pop    %ebp
801032b1:	c3                   	ret    
801032b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801032bb:	31 f6                	xor    %esi,%esi
}
801032bd:	5b                   	pop    %ebx
801032be:	89 f0                	mov    %esi,%eax
801032c0:	5e                   	pop    %esi
801032c1:	5f                   	pop    %edi
801032c2:	5d                   	pop    %ebp
801032c3:	c3                   	ret    
801032c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032cf:	90                   	nop

801032d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801032d0:	55                   	push   %ebp
801032d1:	89 e5                	mov    %esp,%ebp
801032d3:	57                   	push   %edi
801032d4:	56                   	push   %esi
801032d5:	53                   	push   %ebx
801032d6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801032d9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801032e0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801032e7:	c1 e0 08             	shl    $0x8,%eax
801032ea:	09 d0                	or     %edx,%eax
801032ec:	c1 e0 04             	shl    $0x4,%eax
801032ef:	75 1b                	jne    8010330c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801032f1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801032f8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032ff:	c1 e0 08             	shl    $0x8,%eax
80103302:	09 d0                	or     %edx,%eax
80103304:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103307:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010330c:	ba 00 04 00 00       	mov    $0x400,%edx
80103311:	e8 3a ff ff ff       	call   80103250 <mpsearch1>
80103316:	89 c3                	mov    %eax,%ebx
80103318:	85 c0                	test   %eax,%eax
8010331a:	0f 84 40 01 00 00    	je     80103460 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103320:	8b 73 04             	mov    0x4(%ebx),%esi
80103323:	85 f6                	test   %esi,%esi
80103325:	0f 84 25 01 00 00    	je     80103450 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010332b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010332e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103334:	6a 04                	push   $0x4
80103336:	68 bd 7c 10 80       	push   $0x80107cbd
8010333b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010333c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010333f:	e8 4c 15 00 00       	call   80104890 <memcmp>
80103344:	83 c4 10             	add    $0x10,%esp
80103347:	85 c0                	test   %eax,%eax
80103349:	0f 85 01 01 00 00    	jne    80103450 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010334f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103356:	3c 01                	cmp    $0x1,%al
80103358:	74 08                	je     80103362 <mpinit+0x92>
8010335a:	3c 04                	cmp    $0x4,%al
8010335c:	0f 85 ee 00 00 00    	jne    80103450 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103362:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103369:	66 85 d2             	test   %dx,%dx
8010336c:	74 22                	je     80103390 <mpinit+0xc0>
8010336e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103371:	89 f0                	mov    %esi,%eax
  sum = 0;
80103373:	31 d2                	xor    %edx,%edx
80103375:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103378:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010337f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103382:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103384:	39 c7                	cmp    %eax,%edi
80103386:	75 f0                	jne    80103378 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103388:	84 d2                	test   %dl,%dl
8010338a:	0f 85 c0 00 00 00    	jne    80103450 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103390:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103396:	a3 80 a6 14 80       	mov    %eax,0x8014a680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010339b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801033a2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801033a8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033ad:	03 55 e4             	add    -0x1c(%ebp),%edx
801033b0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801033b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033b7:	90                   	nop
801033b8:	39 d0                	cmp    %edx,%eax
801033ba:	73 15                	jae    801033d1 <mpinit+0x101>
    switch(*p){
801033bc:	0f b6 08             	movzbl (%eax),%ecx
801033bf:	80 f9 02             	cmp    $0x2,%cl
801033c2:	74 4c                	je     80103410 <mpinit+0x140>
801033c4:	77 3a                	ja     80103400 <mpinit+0x130>
801033c6:	84 c9                	test   %cl,%cl
801033c8:	74 56                	je     80103420 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801033ca:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033cd:	39 d0                	cmp    %edx,%eax
801033cf:	72 eb                	jb     801033bc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801033d1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801033d4:	85 f6                	test   %esi,%esi
801033d6:	0f 84 d9 00 00 00    	je     801034b5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801033dc:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801033e0:	74 15                	je     801033f7 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033e2:	b8 70 00 00 00       	mov    $0x70,%eax
801033e7:	ba 22 00 00 00       	mov    $0x22,%edx
801033ec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033ed:	ba 23 00 00 00       	mov    $0x23,%edx
801033f2:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801033f3:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033f6:	ee                   	out    %al,(%dx)
  }
}
801033f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033fa:	5b                   	pop    %ebx
801033fb:	5e                   	pop    %esi
801033fc:	5f                   	pop    %edi
801033fd:	5d                   	pop    %ebp
801033fe:	c3                   	ret    
801033ff:	90                   	nop
    switch(*p){
80103400:	83 e9 03             	sub    $0x3,%ecx
80103403:	80 f9 01             	cmp    $0x1,%cl
80103406:	76 c2                	jbe    801033ca <mpinit+0xfa>
80103408:	31 f6                	xor    %esi,%esi
8010340a:	eb ac                	jmp    801033b8 <mpinit+0xe8>
8010340c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103410:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103414:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103417:	88 0d 80 a7 14 80    	mov    %cl,0x8014a780
      continue;
8010341d:	eb 99                	jmp    801033b8 <mpinit+0xe8>
8010341f:	90                   	nop
      if(ncpu < NCPU) {
80103420:	8b 0d 84 a7 14 80    	mov    0x8014a784,%ecx
80103426:	83 f9 07             	cmp    $0x7,%ecx
80103429:	7f 19                	jg     80103444 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010342b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103431:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103435:	83 c1 01             	add    $0x1,%ecx
80103438:	89 0d 84 a7 14 80    	mov    %ecx,0x8014a784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010343e:	88 9f a0 a7 14 80    	mov    %bl,-0x7feb5860(%edi)
      p += sizeof(struct mpproc);
80103444:	83 c0 14             	add    $0x14,%eax
      continue;
80103447:	e9 6c ff ff ff       	jmp    801033b8 <mpinit+0xe8>
8010344c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103450:	83 ec 0c             	sub    $0xc,%esp
80103453:	68 c2 7c 10 80       	push   $0x80107cc2
80103458:	e8 23 cf ff ff       	call   80100380 <panic>
8010345d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103460:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103465:	eb 13                	jmp    8010347a <mpinit+0x1aa>
80103467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010346e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103470:	89 f3                	mov    %esi,%ebx
80103472:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103478:	74 d6                	je     80103450 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010347a:	83 ec 04             	sub    $0x4,%esp
8010347d:	8d 73 10             	lea    0x10(%ebx),%esi
80103480:	6a 04                	push   $0x4
80103482:	68 b8 7c 10 80       	push   $0x80107cb8
80103487:	53                   	push   %ebx
80103488:	e8 03 14 00 00       	call   80104890 <memcmp>
8010348d:	83 c4 10             	add    $0x10,%esp
80103490:	85 c0                	test   %eax,%eax
80103492:	75 dc                	jne    80103470 <mpinit+0x1a0>
80103494:	89 da                	mov    %ebx,%edx
80103496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010349d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801034a0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801034a3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801034a6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801034a8:	39 d6                	cmp    %edx,%esi
801034aa:	75 f4                	jne    801034a0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034ac:	84 c0                	test   %al,%al
801034ae:	75 c0                	jne    80103470 <mpinit+0x1a0>
801034b0:	e9 6b fe ff ff       	jmp    80103320 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801034b5:	83 ec 0c             	sub    $0xc,%esp
801034b8:	68 dc 7c 10 80       	push   $0x80107cdc
801034bd:	e8 be ce ff ff       	call   80100380 <panic>
801034c2:	66 90                	xchg   %ax,%ax
801034c4:	66 90                	xchg   %ax,%ax
801034c6:	66 90                	xchg   %ax,%ax
801034c8:	66 90                	xchg   %ax,%ax
801034ca:	66 90                	xchg   %ax,%ax
801034cc:	66 90                	xchg   %ax,%ax
801034ce:	66 90                	xchg   %ax,%ax

801034d0 <picinit>:
801034d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034d5:	ba 21 00 00 00       	mov    $0x21,%edx
801034da:	ee                   	out    %al,(%dx)
801034db:	ba a1 00 00 00       	mov    $0xa1,%edx
801034e0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801034e1:	c3                   	ret    
801034e2:	66 90                	xchg   %ax,%ax
801034e4:	66 90                	xchg   %ax,%ax
801034e6:	66 90                	xchg   %ax,%ax
801034e8:	66 90                	xchg   %ax,%ax
801034ea:	66 90                	xchg   %ax,%ax
801034ec:	66 90                	xchg   %ax,%ax
801034ee:	66 90                	xchg   %ax,%ax

801034f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	57                   	push   %edi
801034f4:	56                   	push   %esi
801034f5:	53                   	push   %ebx
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801034ff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103505:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010350b:	e8 20 d9 ff ff       	call   80100e30 <filealloc>
80103510:	89 03                	mov    %eax,(%ebx)
80103512:	85 c0                	test   %eax,%eax
80103514:	0f 84 a8 00 00 00    	je     801035c2 <pipealloc+0xd2>
8010351a:	e8 11 d9 ff ff       	call   80100e30 <filealloc>
8010351f:	89 06                	mov    %eax,(%esi)
80103521:	85 c0                	test   %eax,%eax
80103523:	0f 84 87 00 00 00    	je     801035b0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103529:	e8 52 f1 ff ff       	call   80102680 <kalloc>
8010352e:	89 c7                	mov    %eax,%edi
80103530:	85 c0                	test   %eax,%eax
80103532:	0f 84 b0 00 00 00    	je     801035e8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103538:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010353f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103542:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103545:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010354c:	00 00 00 
  p->nwrite = 0;
8010354f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103556:	00 00 00 
  p->nread = 0;
80103559:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103560:	00 00 00 
  initlock(&p->lock, "pipe");
80103563:	68 fb 7c 10 80       	push   $0x80107cfb
80103568:	50                   	push   %eax
80103569:	e8 42 10 00 00       	call   801045b0 <initlock>
  (*f0)->type = FD_PIPE;
8010356e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103570:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103573:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103579:	8b 03                	mov    (%ebx),%eax
8010357b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010357f:	8b 03                	mov    (%ebx),%eax
80103581:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103585:	8b 03                	mov    (%ebx),%eax
80103587:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010358a:	8b 06                	mov    (%esi),%eax
8010358c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103592:	8b 06                	mov    (%esi),%eax
80103594:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103598:	8b 06                	mov    (%esi),%eax
8010359a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010359e:	8b 06                	mov    (%esi),%eax
801035a0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801035a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035a6:	31 c0                	xor    %eax,%eax
}
801035a8:	5b                   	pop    %ebx
801035a9:	5e                   	pop    %esi
801035aa:	5f                   	pop    %edi
801035ab:	5d                   	pop    %ebp
801035ac:	c3                   	ret    
801035ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801035b0:	8b 03                	mov    (%ebx),%eax
801035b2:	85 c0                	test   %eax,%eax
801035b4:	74 1e                	je     801035d4 <pipealloc+0xe4>
    fileclose(*f0);
801035b6:	83 ec 0c             	sub    $0xc,%esp
801035b9:	50                   	push   %eax
801035ba:	e8 31 d9 ff ff       	call   80100ef0 <fileclose>
801035bf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801035c2:	8b 06                	mov    (%esi),%eax
801035c4:	85 c0                	test   %eax,%eax
801035c6:	74 0c                	je     801035d4 <pipealloc+0xe4>
    fileclose(*f1);
801035c8:	83 ec 0c             	sub    $0xc,%esp
801035cb:	50                   	push   %eax
801035cc:	e8 1f d9 ff ff       	call   80100ef0 <fileclose>
801035d1:	83 c4 10             	add    $0x10,%esp
}
801035d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801035d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801035dc:	5b                   	pop    %ebx
801035dd:	5e                   	pop    %esi
801035de:	5f                   	pop    %edi
801035df:	5d                   	pop    %ebp
801035e0:	c3                   	ret    
801035e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801035e8:	8b 03                	mov    (%ebx),%eax
801035ea:	85 c0                	test   %eax,%eax
801035ec:	75 c8                	jne    801035b6 <pipealloc+0xc6>
801035ee:	eb d2                	jmp    801035c2 <pipealloc+0xd2>

801035f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	56                   	push   %esi
801035f4:	53                   	push   %ebx
801035f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035fb:	83 ec 0c             	sub    $0xc,%esp
801035fe:	53                   	push   %ebx
801035ff:	e8 7c 11 00 00       	call   80104780 <acquire>
  if(writable){
80103604:	83 c4 10             	add    $0x10,%esp
80103607:	85 f6                	test   %esi,%esi
80103609:	74 65                	je     80103670 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010360b:	83 ec 0c             	sub    $0xc,%esp
8010360e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103614:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010361b:	00 00 00 
    wakeup(&p->nread);
8010361e:	50                   	push   %eax
8010361f:	e8 bc 0c 00 00       	call   801042e0 <wakeup>
80103624:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103627:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010362d:	85 d2                	test   %edx,%edx
8010362f:	75 0a                	jne    8010363b <pipeclose+0x4b>
80103631:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103637:	85 c0                	test   %eax,%eax
80103639:	74 15                	je     80103650 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010363b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010363e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103641:	5b                   	pop    %ebx
80103642:	5e                   	pop    %esi
80103643:	5d                   	pop    %ebp
    release(&p->lock);
80103644:	e9 d7 10 00 00       	jmp    80104720 <release>
80103649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103650:	83 ec 0c             	sub    $0xc,%esp
80103653:	53                   	push   %ebx
80103654:	e8 c7 10 00 00       	call   80104720 <release>
    kfree((char*)p);
80103659:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010365c:	83 c4 10             	add    $0x10,%esp
}
8010365f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103662:	5b                   	pop    %ebx
80103663:	5e                   	pop    %esi
80103664:	5d                   	pop    %ebp
    kfree((char*)p);
80103665:	e9 56 ee ff ff       	jmp    801024c0 <kfree>
8010366a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103670:	83 ec 0c             	sub    $0xc,%esp
80103673:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103679:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103680:	00 00 00 
    wakeup(&p->nwrite);
80103683:	50                   	push   %eax
80103684:	e8 57 0c 00 00       	call   801042e0 <wakeup>
80103689:	83 c4 10             	add    $0x10,%esp
8010368c:	eb 99                	jmp    80103627 <pipeclose+0x37>
8010368e:	66 90                	xchg   %ax,%ax

80103690 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	57                   	push   %edi
80103694:	56                   	push   %esi
80103695:	53                   	push   %ebx
80103696:	83 ec 28             	sub    $0x28,%esp
80103699:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010369c:	53                   	push   %ebx
8010369d:	e8 de 10 00 00       	call   80104780 <acquire>
  for(i = 0; i < n; i++){
801036a2:	8b 45 10             	mov    0x10(%ebp),%eax
801036a5:	83 c4 10             	add    $0x10,%esp
801036a8:	85 c0                	test   %eax,%eax
801036aa:	0f 8e c0 00 00 00    	jle    80103770 <pipewrite+0xe0>
801036b0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036b3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801036b9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801036bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036c2:	03 45 10             	add    0x10(%ebp),%eax
801036c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036c8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036ce:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036d4:	89 ca                	mov    %ecx,%edx
801036d6:	05 00 02 00 00       	add    $0x200,%eax
801036db:	39 c1                	cmp    %eax,%ecx
801036dd:	74 3f                	je     8010371e <pipewrite+0x8e>
801036df:	eb 67                	jmp    80103748 <pipewrite+0xb8>
801036e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801036e8:	e8 43 03 00 00       	call   80103a30 <myproc>
801036ed:	8b 48 24             	mov    0x24(%eax),%ecx
801036f0:	85 c9                	test   %ecx,%ecx
801036f2:	75 34                	jne    80103728 <pipewrite+0x98>
      wakeup(&p->nread);
801036f4:	83 ec 0c             	sub    $0xc,%esp
801036f7:	57                   	push   %edi
801036f8:	e8 e3 0b 00 00       	call   801042e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036fd:	58                   	pop    %eax
801036fe:	5a                   	pop    %edx
801036ff:	53                   	push   %ebx
80103700:	56                   	push   %esi
80103701:	e8 1a 0b 00 00       	call   80104220 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103706:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010370c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103712:	83 c4 10             	add    $0x10,%esp
80103715:	05 00 02 00 00       	add    $0x200,%eax
8010371a:	39 c2                	cmp    %eax,%edx
8010371c:	75 2a                	jne    80103748 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010371e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103724:	85 c0                	test   %eax,%eax
80103726:	75 c0                	jne    801036e8 <pipewrite+0x58>
        release(&p->lock);
80103728:	83 ec 0c             	sub    $0xc,%esp
8010372b:	53                   	push   %ebx
8010372c:	e8 ef 0f 00 00       	call   80104720 <release>
        return -1;
80103731:	83 c4 10             	add    $0x10,%esp
80103734:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103739:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010373c:	5b                   	pop    %ebx
8010373d:	5e                   	pop    %esi
8010373e:	5f                   	pop    %edi
8010373f:	5d                   	pop    %ebp
80103740:	c3                   	ret    
80103741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103748:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010374b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010374e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103754:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010375a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010375d:	83 c6 01             	add    $0x1,%esi
80103760:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103763:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103767:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010376a:	0f 85 58 ff ff ff    	jne    801036c8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103770:	83 ec 0c             	sub    $0xc,%esp
80103773:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103779:	50                   	push   %eax
8010377a:	e8 61 0b 00 00       	call   801042e0 <wakeup>
  release(&p->lock);
8010377f:	89 1c 24             	mov    %ebx,(%esp)
80103782:	e8 99 0f 00 00       	call   80104720 <release>
  return n;
80103787:	8b 45 10             	mov    0x10(%ebp),%eax
8010378a:	83 c4 10             	add    $0x10,%esp
8010378d:	eb aa                	jmp    80103739 <pipewrite+0xa9>
8010378f:	90                   	nop

80103790 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	57                   	push   %edi
80103794:	56                   	push   %esi
80103795:	53                   	push   %ebx
80103796:	83 ec 18             	sub    $0x18,%esp
80103799:	8b 75 08             	mov    0x8(%ebp),%esi
8010379c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010379f:	56                   	push   %esi
801037a0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037a6:	e8 d5 0f 00 00       	call   80104780 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037ab:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037b1:	83 c4 10             	add    $0x10,%esp
801037b4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801037ba:	74 2f                	je     801037eb <piperead+0x5b>
801037bc:	eb 37                	jmp    801037f5 <piperead+0x65>
801037be:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801037c0:	e8 6b 02 00 00       	call   80103a30 <myproc>
801037c5:	8b 48 24             	mov    0x24(%eax),%ecx
801037c8:	85 c9                	test   %ecx,%ecx
801037ca:	0f 85 80 00 00 00    	jne    80103850 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801037d0:	83 ec 08             	sub    $0x8,%esp
801037d3:	56                   	push   %esi
801037d4:	53                   	push   %ebx
801037d5:	e8 46 0a 00 00       	call   80104220 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037da:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801037e0:	83 c4 10             	add    $0x10,%esp
801037e3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801037e9:	75 0a                	jne    801037f5 <piperead+0x65>
801037eb:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801037f1:	85 c0                	test   %eax,%eax
801037f3:	75 cb                	jne    801037c0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037f5:	8b 55 10             	mov    0x10(%ebp),%edx
801037f8:	31 db                	xor    %ebx,%ebx
801037fa:	85 d2                	test   %edx,%edx
801037fc:	7f 20                	jg     8010381e <piperead+0x8e>
801037fe:	eb 2c                	jmp    8010382c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103800:	8d 48 01             	lea    0x1(%eax),%ecx
80103803:	25 ff 01 00 00       	and    $0x1ff,%eax
80103808:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010380e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103813:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103816:	83 c3 01             	add    $0x1,%ebx
80103819:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010381c:	74 0e                	je     8010382c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010381e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103824:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010382a:	75 d4                	jne    80103800 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010382c:	83 ec 0c             	sub    $0xc,%esp
8010382f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103835:	50                   	push   %eax
80103836:	e8 a5 0a 00 00       	call   801042e0 <wakeup>
  release(&p->lock);
8010383b:	89 34 24             	mov    %esi,(%esp)
8010383e:	e8 dd 0e 00 00       	call   80104720 <release>
  return i;
80103843:	83 c4 10             	add    $0x10,%esp
}
80103846:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103849:	89 d8                	mov    %ebx,%eax
8010384b:	5b                   	pop    %ebx
8010384c:	5e                   	pop    %esi
8010384d:	5f                   	pop    %edi
8010384e:	5d                   	pop    %ebp
8010384f:	c3                   	ret    
      release(&p->lock);
80103850:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103853:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103858:	56                   	push   %esi
80103859:	e8 c2 0e 00 00       	call   80104720 <release>
      return -1;
8010385e:	83 c4 10             	add    $0x10,%esp
}
80103861:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103864:	89 d8                	mov    %ebx,%eax
80103866:	5b                   	pop    %ebx
80103867:	5e                   	pop    %esi
80103868:	5f                   	pop    %edi
80103869:	5d                   	pop    %ebp
8010386a:	c3                   	ret    
8010386b:	66 90                	xchg   %ax,%ax
8010386d:	66 90                	xchg   %ax,%ax
8010386f:	90                   	nop

80103870 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103874:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
{
80103879:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010387c:	68 20 ad 14 80       	push   $0x8014ad20
80103881:	e8 fa 0e 00 00       	call   80104780 <acquire>
80103886:	83 c4 10             	add    $0x10,%esp
80103889:	eb 10                	jmp    8010389b <allocproc+0x2b>
8010388b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010388f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103890:	83 c3 7c             	add    $0x7c,%ebx
80103893:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
80103899:	74 75                	je     80103910 <allocproc+0xa0>
    if(p->state == UNUSED)
8010389b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010389e:	85 c0                	test   %eax,%eax
801038a0:	75 ee                	jne    80103890 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801038a2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801038a7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801038aa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801038b1:	89 43 10             	mov    %eax,0x10(%ebx)
801038b4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801038b7:	68 20 ad 14 80       	push   $0x8014ad20
  p->pid = nextpid++;
801038bc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801038c2:	e8 59 0e 00 00       	call   80104720 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801038c7:	e8 b4 ed ff ff       	call   80102680 <kalloc>
801038cc:	83 c4 10             	add    $0x10,%esp
801038cf:	89 43 08             	mov    %eax,0x8(%ebx)
801038d2:	85 c0                	test   %eax,%eax
801038d4:	74 53                	je     80103929 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801038d6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801038dc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801038df:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801038e4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801038e7:	c7 40 14 37 5b 10 80 	movl   $0x80105b37,0x14(%eax)
  p->context = (struct context*)sp;
801038ee:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038f1:	6a 14                	push   $0x14
801038f3:	6a 00                	push   $0x0
801038f5:	50                   	push   %eax
801038f6:	e8 45 0f 00 00       	call   80104840 <memset>
  p->context->eip = (uint)forkret;
801038fb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801038fe:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103901:	c7 40 10 40 39 10 80 	movl   $0x80103940,0x10(%eax)
}
80103908:	89 d8                	mov    %ebx,%eax
8010390a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010390d:	c9                   	leave  
8010390e:	c3                   	ret    
8010390f:	90                   	nop
  release(&ptable.lock);
80103910:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103913:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103915:	68 20 ad 14 80       	push   $0x8014ad20
8010391a:	e8 01 0e 00 00       	call   80104720 <release>
}
8010391f:	89 d8                	mov    %ebx,%eax
  return 0;
80103921:	83 c4 10             	add    $0x10,%esp
}
80103924:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103927:	c9                   	leave  
80103928:	c3                   	ret    
    p->state = UNUSED;
80103929:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103930:	31 db                	xor    %ebx,%ebx
}
80103932:	89 d8                	mov    %ebx,%eax
80103934:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103937:	c9                   	leave  
80103938:	c3                   	ret    
80103939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103940 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103946:	68 20 ad 14 80       	push   $0x8014ad20
8010394b:	e8 d0 0d 00 00       	call   80104720 <release>

  if (first) {
80103950:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	85 c0                	test   %eax,%eax
8010395a:	75 04                	jne    80103960 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010395c:	c9                   	leave  
8010395d:	c3                   	ret    
8010395e:	66 90                	xchg   %ax,%ax
    first = 0;
80103960:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103967:	00 00 00 
    iinit(ROOTDEV);
8010396a:	83 ec 0c             	sub    $0xc,%esp
8010396d:	6a 01                	push   $0x1
8010396f:	e8 ec db ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103974:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010397b:	e8 00 f4 ff ff       	call   80102d80 <initlog>
}
80103980:	83 c4 10             	add    $0x10,%esp
80103983:	c9                   	leave  
80103984:	c3                   	ret    
80103985:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010398c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103990 <pinit>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103996:	68 00 7d 10 80       	push   $0x80107d00
8010399b:	68 20 ad 14 80       	push   $0x8014ad20
801039a0:	e8 0b 0c 00 00       	call   801045b0 <initlock>
}
801039a5:	83 c4 10             	add    $0x10,%esp
801039a8:	c9                   	leave  
801039a9:	c3                   	ret    
801039aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039b0 <mycpu>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	56                   	push   %esi
801039b4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039b5:	9c                   	pushf  
801039b6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039b7:	f6 c4 02             	test   $0x2,%ah
801039ba:	75 46                	jne    80103a02 <mycpu+0x52>
  apicid = lapicid();
801039bc:	e8 ef ef ff ff       	call   801029b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039c1:	8b 35 84 a7 14 80    	mov    0x8014a784,%esi
801039c7:	85 f6                	test   %esi,%esi
801039c9:	7e 2a                	jle    801039f5 <mycpu+0x45>
801039cb:	31 d2                	xor    %edx,%edx
801039cd:	eb 08                	jmp    801039d7 <mycpu+0x27>
801039cf:	90                   	nop
801039d0:	83 c2 01             	add    $0x1,%edx
801039d3:	39 f2                	cmp    %esi,%edx
801039d5:	74 1e                	je     801039f5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
801039d7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039dd:	0f b6 99 a0 a7 14 80 	movzbl -0x7feb5860(%ecx),%ebx
801039e4:	39 c3                	cmp    %eax,%ebx
801039e6:	75 e8                	jne    801039d0 <mycpu+0x20>
}
801039e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039eb:	8d 81 a0 a7 14 80    	lea    -0x7feb5860(%ecx),%eax
}
801039f1:	5b                   	pop    %ebx
801039f2:	5e                   	pop    %esi
801039f3:	5d                   	pop    %ebp
801039f4:	c3                   	ret    
  panic("unknown apicid\n");
801039f5:	83 ec 0c             	sub    $0xc,%esp
801039f8:	68 07 7d 10 80       	push   $0x80107d07
801039fd:	e8 7e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a02:	83 ec 0c             	sub    $0xc,%esp
80103a05:	68 e4 7d 10 80       	push   $0x80107de4
80103a0a:	e8 71 c9 ff ff       	call   80100380 <panic>
80103a0f:	90                   	nop

80103a10 <cpuid>:
cpuid() {
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a16:	e8 95 ff ff ff       	call   801039b0 <mycpu>
}
80103a1b:	c9                   	leave  
  return mycpu()-cpus;
80103a1c:	2d a0 a7 14 80       	sub    $0x8014a7a0,%eax
80103a21:	c1 f8 04             	sar    $0x4,%eax
80103a24:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a2a:	c3                   	ret    
80103a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a2f:	90                   	nop

80103a30 <myproc>:
myproc(void) {
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	53                   	push   %ebx
80103a34:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a37:	e8 f4 0b 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103a3c:	e8 6f ff ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103a41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a47:	e8 34 0c 00 00       	call   80104680 <popcli>
}
80103a4c:	89 d8                	mov    %ebx,%eax
80103a4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a51:	c9                   	leave  
80103a52:	c3                   	ret    
80103a53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a60 <userinit>:
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	53                   	push   %ebx
80103a64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a67:	e8 04 fe ff ff       	call   80103870 <allocproc>
80103a6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a6e:	a3 54 cc 14 80       	mov    %eax,0x8014cc54
  if((p->pgdir = setupkvm()) == 0)
80103a73:	e8 c8 38 00 00       	call   80107340 <setupkvm>
80103a78:	89 43 04             	mov    %eax,0x4(%ebx)
80103a7b:	85 c0                	test   %eax,%eax
80103a7d:	0f 84 bd 00 00 00    	je     80103b40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a83:	83 ec 04             	sub    $0x4,%esp
80103a86:	68 2c 00 00 00       	push   $0x2c
80103a8b:	68 60 b4 10 80       	push   $0x8010b460
80103a90:	50                   	push   %eax
80103a91:	e8 3a 35 00 00       	call   80106fd0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a9f:	6a 4c                	push   $0x4c
80103aa1:	6a 00                	push   $0x0
80103aa3:	ff 73 18             	push   0x18(%ebx)
80103aa6:	e8 95 0d 00 00       	call   80104840 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103aab:	8b 43 18             	mov    0x18(%ebx),%eax
80103aae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ab3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ab6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103abb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103abf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ac6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103acd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ad1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ad4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ad8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103adc:	8b 43 18             	mov    0x18(%ebx),%eax
80103adf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ae6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103af0:	8b 43 18             	mov    0x18(%ebx),%eax
80103af3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103afa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103afd:	6a 10                	push   $0x10
80103aff:	68 30 7d 10 80       	push   $0x80107d30
80103b04:	50                   	push   %eax
80103b05:	e8 f6 0e 00 00       	call   80104a00 <safestrcpy>
  p->cwd = namei("/");
80103b0a:	c7 04 24 39 7d 10 80 	movl   $0x80107d39,(%esp)
80103b11:	e8 8a e5 ff ff       	call   801020a0 <namei>
80103b16:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b19:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103b20:	e8 5b 0c 00 00       	call   80104780 <acquire>
  p->state = RUNNABLE;
80103b25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b2c:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103b33:	e8 e8 0b 00 00       	call   80104720 <release>
}
80103b38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b3b:	83 c4 10             	add    $0x10,%esp
80103b3e:	c9                   	leave  
80103b3f:	c3                   	ret    
    panic("userinit: out of memory?");
80103b40:	83 ec 0c             	sub    $0xc,%esp
80103b43:	68 17 7d 10 80       	push   $0x80107d17
80103b48:	e8 33 c8 ff ff       	call   80100380 <panic>
80103b4d:	8d 76 00             	lea    0x0(%esi),%esi

80103b50 <growproc>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	56                   	push   %esi
80103b54:	53                   	push   %ebx
80103b55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b58:	e8 d3 0a 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103b5d:	e8 4e fe ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103b62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b68:	e8 13 0b 00 00       	call   80104680 <popcli>
  sz = curproc->sz;
80103b6d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b6f:	85 f6                	test   %esi,%esi
80103b71:	7f 1d                	jg     80103b90 <growproc+0x40>
  } else if(n < 0){
80103b73:	75 3b                	jne    80103bb0 <growproc+0x60>
  switchuvm(curproc);
80103b75:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b78:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b7a:	53                   	push   %ebx
80103b7b:	e8 40 33 00 00       	call   80106ec0 <switchuvm>
  return 0;
80103b80:	83 c4 10             	add    $0x10,%esp
80103b83:	31 c0                	xor    %eax,%eax
}
80103b85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b88:	5b                   	pop    %ebx
80103b89:	5e                   	pop    %esi
80103b8a:	5d                   	pop    %ebp
80103b8b:	c3                   	ret    
80103b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b90:	83 ec 04             	sub    $0x4,%esp
80103b93:	01 c6                	add    %eax,%esi
80103b95:	56                   	push   %esi
80103b96:	50                   	push   %eax
80103b97:	ff 73 04             	push   0x4(%ebx)
80103b9a:	e8 b1 35 00 00       	call   80107150 <allocuvm>
80103b9f:	83 c4 10             	add    $0x10,%esp
80103ba2:	85 c0                	test   %eax,%eax
80103ba4:	75 cf                	jne    80103b75 <growproc+0x25>
      return -1;
80103ba6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bab:	eb d8                	jmp    80103b85 <growproc+0x35>
80103bad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bb0:	83 ec 04             	sub    $0x4,%esp
80103bb3:	01 c6                	add    %eax,%esi
80103bb5:	56                   	push   %esi
80103bb6:	50                   	push   %eax
80103bb7:	ff 73 04             	push   0x4(%ebx)
80103bba:	e8 d1 36 00 00       	call   80107290 <deallocuvm>
80103bbf:	83 c4 10             	add    $0x10,%esp
80103bc2:	85 c0                	test   %eax,%eax
80103bc4:	75 af                	jne    80103b75 <growproc+0x25>
80103bc6:	eb de                	jmp    80103ba6 <growproc+0x56>
80103bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bcf:	90                   	nop

80103bd0 <fork>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	57                   	push   %edi
80103bd4:	56                   	push   %esi
80103bd5:	53                   	push   %ebx
80103bd6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103bd9:	e8 52 0a 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103bde:	e8 cd fd ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103be3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103be9:	e8 92 0a 00 00       	call   80104680 <popcli>
  if((np = allocproc()) == 0){
80103bee:	e8 7d fc ff ff       	call   80103870 <allocproc>
80103bf3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103bf6:	85 c0                	test   %eax,%eax
80103bf8:	0f 84 b7 00 00 00    	je     80103cb5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103bfe:	83 ec 08             	sub    $0x8,%esp
80103c01:	ff 33                	push   (%ebx)
80103c03:	89 c7                	mov    %eax,%edi
80103c05:	ff 73 04             	push   0x4(%ebx)
80103c08:	e8 23 38 00 00       	call   80107430 <copyuvm>
80103c0d:	83 c4 10             	add    $0x10,%esp
80103c10:	89 47 04             	mov    %eax,0x4(%edi)
80103c13:	85 c0                	test   %eax,%eax
80103c15:	0f 84 a1 00 00 00    	je     80103cbc <fork+0xec>
  np->sz = curproc->sz;
80103c1b:	8b 03                	mov    (%ebx),%eax
80103c1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c20:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103c22:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103c25:	89 c8                	mov    %ecx,%eax
80103c27:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103c2a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c2f:	8b 73 18             	mov    0x18(%ebx),%esi
80103c32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c34:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c36:	8b 40 18             	mov    0x18(%eax),%eax
80103c39:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103c40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c44:	85 c0                	test   %eax,%eax
80103c46:	74 13                	je     80103c5b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c48:	83 ec 0c             	sub    $0xc,%esp
80103c4b:	50                   	push   %eax
80103c4c:	e8 4f d2 ff ff       	call   80100ea0 <filedup>
80103c51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c54:	83 c4 10             	add    $0x10,%esp
80103c57:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c5b:	83 c6 01             	add    $0x1,%esi
80103c5e:	83 fe 10             	cmp    $0x10,%esi
80103c61:	75 dd                	jne    80103c40 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103c63:	83 ec 0c             	sub    $0xc,%esp
80103c66:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c69:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c6c:	e8 df da ff ff       	call   80101750 <idup>
80103c71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c74:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c77:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c7a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c7d:	6a 10                	push   $0x10
80103c7f:	53                   	push   %ebx
80103c80:	50                   	push   %eax
80103c81:	e8 7a 0d 00 00       	call   80104a00 <safestrcpy>
  pid = np->pid;
80103c86:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c89:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103c90:	e8 eb 0a 00 00       	call   80104780 <acquire>
  np->state = RUNNABLE;
80103c95:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c9c:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103ca3:	e8 78 0a 00 00       	call   80104720 <release>
  return pid;
80103ca8:	83 c4 10             	add    $0x10,%esp
}
80103cab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cae:	89 d8                	mov    %ebx,%eax
80103cb0:	5b                   	pop    %ebx
80103cb1:	5e                   	pop    %esi
80103cb2:	5f                   	pop    %edi
80103cb3:	5d                   	pop    %ebp
80103cb4:	c3                   	ret    
    return -1;
80103cb5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103cba:	eb ef                	jmp    80103cab <fork+0xdb>
    kfree(np->kstack);
80103cbc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103cbf:	83 ec 0c             	sub    $0xc,%esp
80103cc2:	ff 73 08             	push   0x8(%ebx)
80103cc5:	e8 f6 e7 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103cca:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103cd1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103cd4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103cdb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ce0:	eb c9                	jmp    80103cab <fork+0xdb>
80103ce2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103cf0 <forkcow>:
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	57                   	push   %edi
80103cf4:	56                   	push   %esi
80103cf5:	53                   	push   %ebx
80103cf6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103cf9:	e8 32 09 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103cfe:	e8 ad fc ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103d03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d09:	e8 72 09 00 00       	call   80104680 <popcli>
  if((np = allocproc()) == 0){
80103d0e:	e8 5d fb ff ff       	call   80103870 <allocproc>
80103d13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d16:	85 c0                	test   %eax,%eax
80103d18:	0f 84 b7 00 00 00    	je     80103dd5 <forkcow+0xe5>
  if((np->pgdir = copyuvmcow(curproc->pgdir, curproc->sz)) == 0){
80103d1e:	83 ec 08             	sub    $0x8,%esp
80103d21:	ff 33                	push   (%ebx)
80103d23:	89 c7                	mov    %eax,%edi
80103d25:	ff 73 04             	push   0x4(%ebx)
80103d28:	e8 33 38 00 00       	call   80107560 <copyuvmcow>
80103d2d:	83 c4 10             	add    $0x10,%esp
80103d30:	89 47 04             	mov    %eax,0x4(%edi)
80103d33:	85 c0                	test   %eax,%eax
80103d35:	0f 84 a1 00 00 00    	je     80103ddc <forkcow+0xec>
  np->sz = curproc->sz;
80103d3b:	8b 03                	mov    (%ebx),%eax
80103d3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d40:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d42:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103d45:	89 c8                	mov    %ecx,%eax
80103d47:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d4a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d4f:	8b 73 18             	mov    0x18(%ebx),%esi
80103d52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d54:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d56:	8b 40 18             	mov    0x18(%eax),%eax
80103d59:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103d60:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d64:	85 c0                	test   %eax,%eax
80103d66:	74 13                	je     80103d7b <forkcow+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d68:	83 ec 0c             	sub    $0xc,%esp
80103d6b:	50                   	push   %eax
80103d6c:	e8 2f d1 ff ff       	call   80100ea0 <filedup>
80103d71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d74:	83 c4 10             	add    $0x10,%esp
80103d77:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d7b:	83 c6 01             	add    $0x1,%esi
80103d7e:	83 fe 10             	cmp    $0x10,%esi
80103d81:	75 dd                	jne    80103d60 <forkcow+0x70>
  np->cwd = idup(curproc->cwd);
80103d83:	83 ec 0c             	sub    $0xc,%esp
80103d86:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d89:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d8c:	e8 bf d9 ff ff       	call   80101750 <idup>
80103d91:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d94:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d97:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d9a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d9d:	6a 10                	push   $0x10
80103d9f:	53                   	push   %ebx
80103da0:	50                   	push   %eax
80103da1:	e8 5a 0c 00 00       	call   80104a00 <safestrcpy>
  pid = np->pid;
80103da6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103da9:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103db0:	e8 cb 09 00 00       	call   80104780 <acquire>
  np->state = RUNNABLE;
80103db5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103dbc:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103dc3:	e8 58 09 00 00       	call   80104720 <release>
  return pid;
80103dc8:	83 c4 10             	add    $0x10,%esp
}
80103dcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dce:	89 d8                	mov    %ebx,%eax
80103dd0:	5b                   	pop    %ebx
80103dd1:	5e                   	pop    %esi
80103dd2:	5f                   	pop    %edi
80103dd3:	5d                   	pop    %ebp
80103dd4:	c3                   	ret    
    return -1;
80103dd5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103dda:	eb ef                	jmp    80103dcb <forkcow+0xdb>
    kfree(np->kstack);
80103ddc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ddf:	83 ec 0c             	sub    $0xc,%esp
80103de2:	ff 73 08             	push   0x8(%ebx)
80103de5:	e8 d6 e6 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103dea:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103df1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103df4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103dfb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e00:	eb c9                	jmp    80103dcb <forkcow+0xdb>
80103e02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e10 <scheduler>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	57                   	push   %edi
80103e14:	56                   	push   %esi
80103e15:	53                   	push   %ebx
80103e16:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e19:	e8 92 fb ff ff       	call   801039b0 <mycpu>
  c->proc = 0;
80103e1e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e25:	00 00 00 
  struct cpu *c = mycpu();
80103e28:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e2a:	8d 78 04             	lea    0x4(%eax),%edi
80103e2d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e30:	fb                   	sti    
    acquire(&ptable.lock);
80103e31:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e34:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
    acquire(&ptable.lock);
80103e39:	68 20 ad 14 80       	push   $0x8014ad20
80103e3e:	e8 3d 09 00 00       	call   80104780 <acquire>
80103e43:	83 c4 10             	add    $0x10,%esp
80103e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e4d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103e50:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e54:	75 33                	jne    80103e89 <scheduler+0x79>
      switchuvm(p);
80103e56:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e59:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e5f:	53                   	push   %ebx
80103e60:	e8 5b 30 00 00       	call   80106ec0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103e65:	58                   	pop    %eax
80103e66:	5a                   	pop    %edx
80103e67:	ff 73 1c             	push   0x1c(%ebx)
80103e6a:	57                   	push   %edi
      p->state = RUNNING;
80103e6b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103e72:	e8 e4 0b 00 00       	call   80104a5b <swtch>
      switchkvm();
80103e77:	e8 34 30 00 00       	call   80106eb0 <switchkvm>
      c->proc = 0;
80103e7c:	83 c4 10             	add    $0x10,%esp
80103e7f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e86:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e89:	83 c3 7c             	add    $0x7c,%ebx
80103e8c:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
80103e92:	75 bc                	jne    80103e50 <scheduler+0x40>
    release(&ptable.lock);
80103e94:	83 ec 0c             	sub    $0xc,%esp
80103e97:	68 20 ad 14 80       	push   $0x8014ad20
80103e9c:	e8 7f 08 00 00       	call   80104720 <release>
    sti();
80103ea1:	83 c4 10             	add    $0x10,%esp
80103ea4:	eb 8a                	jmp    80103e30 <scheduler+0x20>
80103ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ead:	8d 76 00             	lea    0x0(%esi),%esi

80103eb0 <sched>:
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	56                   	push   %esi
80103eb4:	53                   	push   %ebx
  pushcli();
80103eb5:	e8 76 07 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103eba:	e8 f1 fa ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103ebf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ec5:	e8 b6 07 00 00       	call   80104680 <popcli>
  if(!holding(&ptable.lock))
80103eca:	83 ec 0c             	sub    $0xc,%esp
80103ecd:	68 20 ad 14 80       	push   $0x8014ad20
80103ed2:	e8 09 08 00 00       	call   801046e0 <holding>
80103ed7:	83 c4 10             	add    $0x10,%esp
80103eda:	85 c0                	test   %eax,%eax
80103edc:	74 4f                	je     80103f2d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103ede:	e8 cd fa ff ff       	call   801039b0 <mycpu>
80103ee3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103eea:	75 68                	jne    80103f54 <sched+0xa4>
  if(p->state == RUNNING)
80103eec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ef0:	74 55                	je     80103f47 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ef2:	9c                   	pushf  
80103ef3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ef4:	f6 c4 02             	test   $0x2,%ah
80103ef7:	75 41                	jne    80103f3a <sched+0x8a>
  intena = mycpu()->intena;
80103ef9:	e8 b2 fa ff ff       	call   801039b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103efe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f01:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f07:	e8 a4 fa ff ff       	call   801039b0 <mycpu>
80103f0c:	83 ec 08             	sub    $0x8,%esp
80103f0f:	ff 70 04             	push   0x4(%eax)
80103f12:	53                   	push   %ebx
80103f13:	e8 43 0b 00 00       	call   80104a5b <swtch>
  mycpu()->intena = intena;
80103f18:	e8 93 fa ff ff       	call   801039b0 <mycpu>
}
80103f1d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f20:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f29:	5b                   	pop    %ebx
80103f2a:	5e                   	pop    %esi
80103f2b:	5d                   	pop    %ebp
80103f2c:	c3                   	ret    
    panic("sched ptable.lock");
80103f2d:	83 ec 0c             	sub    $0xc,%esp
80103f30:	68 3b 7d 10 80       	push   $0x80107d3b
80103f35:	e8 46 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103f3a:	83 ec 0c             	sub    $0xc,%esp
80103f3d:	68 67 7d 10 80       	push   $0x80107d67
80103f42:	e8 39 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103f47:	83 ec 0c             	sub    $0xc,%esp
80103f4a:	68 59 7d 10 80       	push   $0x80107d59
80103f4f:	e8 2c c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103f54:	83 ec 0c             	sub    $0xc,%esp
80103f57:	68 4d 7d 10 80       	push   $0x80107d4d
80103f5c:	e8 1f c4 ff ff       	call   80100380 <panic>
80103f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f6f:	90                   	nop

80103f70 <exit>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	57                   	push   %edi
80103f74:	56                   	push   %esi
80103f75:	53                   	push   %ebx
80103f76:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103f79:	e8 b2 fa ff ff       	call   80103a30 <myproc>
  if(curproc == initproc)
80103f7e:	39 05 54 cc 14 80    	cmp    %eax,0x8014cc54
80103f84:	0f 84 fd 00 00 00    	je     80104087 <exit+0x117>
80103f8a:	89 c3                	mov    %eax,%ebx
80103f8c:	8d 70 28             	lea    0x28(%eax),%esi
80103f8f:	8d 78 68             	lea    0x68(%eax),%edi
80103f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103f98:	8b 06                	mov    (%esi),%eax
80103f9a:	85 c0                	test   %eax,%eax
80103f9c:	74 12                	je     80103fb0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103f9e:	83 ec 0c             	sub    $0xc,%esp
80103fa1:	50                   	push   %eax
80103fa2:	e8 49 cf ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103fa7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103fad:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103fb0:	83 c6 04             	add    $0x4,%esi
80103fb3:	39 f7                	cmp    %esi,%edi
80103fb5:	75 e1                	jne    80103f98 <exit+0x28>
  begin_op();
80103fb7:	e8 64 ee ff ff       	call   80102e20 <begin_op>
  iput(curproc->cwd);
80103fbc:	83 ec 0c             	sub    $0xc,%esp
80103fbf:	ff 73 68             	push   0x68(%ebx)
80103fc2:	e8 e9 d8 ff ff       	call   801018b0 <iput>
  end_op();
80103fc7:	e8 c4 ee ff ff       	call   80102e90 <end_op>
  curproc->cwd = 0;
80103fcc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103fd3:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103fda:	e8 a1 07 00 00       	call   80104780 <acquire>
  wakeup1(curproc->parent);
80103fdf:	8b 53 14             	mov    0x14(%ebx),%edx
80103fe2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fe5:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
80103fea:	eb 0e                	jmp    80103ffa <exit+0x8a>
80103fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ff0:	83 c0 7c             	add    $0x7c,%eax
80103ff3:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80103ff8:	74 1c                	je     80104016 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103ffa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ffe:	75 f0                	jne    80103ff0 <exit+0x80>
80104000:	3b 50 20             	cmp    0x20(%eax),%edx
80104003:	75 eb                	jne    80103ff0 <exit+0x80>
      p->state = RUNNABLE;
80104005:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010400c:	83 c0 7c             	add    $0x7c,%eax
8010400f:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104014:	75 e4                	jne    80103ffa <exit+0x8a>
      p->parent = initproc;
80104016:	8b 0d 54 cc 14 80    	mov    0x8014cc54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010401c:	ba 54 ad 14 80       	mov    $0x8014ad54,%edx
80104021:	eb 10                	jmp    80104033 <exit+0xc3>
80104023:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104027:	90                   	nop
80104028:	83 c2 7c             	add    $0x7c,%edx
8010402b:	81 fa 54 cc 14 80    	cmp    $0x8014cc54,%edx
80104031:	74 3b                	je     8010406e <exit+0xfe>
    if(p->parent == curproc){
80104033:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104036:	75 f0                	jne    80104028 <exit+0xb8>
      if(p->state == ZOMBIE)
80104038:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010403c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010403f:	75 e7                	jne    80104028 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104041:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
80104046:	eb 12                	jmp    8010405a <exit+0xea>
80104048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010404f:	90                   	nop
80104050:	83 c0 7c             	add    $0x7c,%eax
80104053:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104058:	74 ce                	je     80104028 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010405a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010405e:	75 f0                	jne    80104050 <exit+0xe0>
80104060:	3b 48 20             	cmp    0x20(%eax),%ecx
80104063:	75 eb                	jne    80104050 <exit+0xe0>
      p->state = RUNNABLE;
80104065:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010406c:	eb e2                	jmp    80104050 <exit+0xe0>
  curproc->state = ZOMBIE;
8010406e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104075:	e8 36 fe ff ff       	call   80103eb0 <sched>
  panic("zombie exit");
8010407a:	83 ec 0c             	sub    $0xc,%esp
8010407d:	68 88 7d 10 80       	push   $0x80107d88
80104082:	e8 f9 c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104087:	83 ec 0c             	sub    $0xc,%esp
8010408a:	68 7b 7d 10 80       	push   $0x80107d7b
8010408f:	e8 ec c2 ff ff       	call   80100380 <panic>
80104094:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010409b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010409f:	90                   	nop

801040a0 <wait>:
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	56                   	push   %esi
801040a4:	53                   	push   %ebx
  pushcli();
801040a5:	e8 86 05 00 00       	call   80104630 <pushcli>
  c = mycpu();
801040aa:	e8 01 f9 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
801040af:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040b5:	e8 c6 05 00 00       	call   80104680 <popcli>
  acquire(&ptable.lock);
801040ba:	83 ec 0c             	sub    $0xc,%esp
801040bd:	68 20 ad 14 80       	push   $0x8014ad20
801040c2:	e8 b9 06 00 00       	call   80104780 <acquire>
801040c7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040ca:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040cc:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
801040d1:	eb 10                	jmp    801040e3 <wait+0x43>
801040d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040d7:	90                   	nop
801040d8:	83 c3 7c             	add    $0x7c,%ebx
801040db:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
801040e1:	74 1b                	je     801040fe <wait+0x5e>
      if(p->parent != curproc)
801040e3:	39 73 14             	cmp    %esi,0x14(%ebx)
801040e6:	75 f0                	jne    801040d8 <wait+0x38>
      if(p->state == ZOMBIE){
801040e8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801040ec:	74 62                	je     80104150 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040ee:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801040f1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040f6:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
801040fc:	75 e5                	jne    801040e3 <wait+0x43>
    if(!havekids || curproc->killed){
801040fe:	85 c0                	test   %eax,%eax
80104100:	0f 84 a0 00 00 00    	je     801041a6 <wait+0x106>
80104106:	8b 46 24             	mov    0x24(%esi),%eax
80104109:	85 c0                	test   %eax,%eax
8010410b:	0f 85 95 00 00 00    	jne    801041a6 <wait+0x106>
  pushcli();
80104111:	e8 1a 05 00 00       	call   80104630 <pushcli>
  c = mycpu();
80104116:	e8 95 f8 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
8010411b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104121:	e8 5a 05 00 00       	call   80104680 <popcli>
  if(p == 0)
80104126:	85 db                	test   %ebx,%ebx
80104128:	0f 84 8f 00 00 00    	je     801041bd <wait+0x11d>
  p->chan = chan;
8010412e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104131:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104138:	e8 73 fd ff ff       	call   80103eb0 <sched>
  p->chan = 0;
8010413d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104144:	eb 84                	jmp    801040ca <wait+0x2a>
80104146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010414d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104150:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104153:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104156:	ff 73 08             	push   0x8(%ebx)
80104159:	e8 62 e3 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
8010415e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104165:	5a                   	pop    %edx
80104166:	ff 73 04             	push   0x4(%ebx)
80104169:	e8 52 31 00 00       	call   801072c0 <freevm>
        p->pid = 0;
8010416e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104175:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010417c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104180:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104187:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010418e:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80104195:	e8 86 05 00 00       	call   80104720 <release>
        return pid;
8010419a:	83 c4 10             	add    $0x10,%esp
}
8010419d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041a0:	89 f0                	mov    %esi,%eax
801041a2:	5b                   	pop    %ebx
801041a3:	5e                   	pop    %esi
801041a4:	5d                   	pop    %ebp
801041a5:	c3                   	ret    
      release(&ptable.lock);
801041a6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041a9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041ae:	68 20 ad 14 80       	push   $0x8014ad20
801041b3:	e8 68 05 00 00       	call   80104720 <release>
      return -1;
801041b8:	83 c4 10             	add    $0x10,%esp
801041bb:	eb e0                	jmp    8010419d <wait+0xfd>
    panic("sleep");
801041bd:	83 ec 0c             	sub    $0xc,%esp
801041c0:	68 94 7d 10 80       	push   $0x80107d94
801041c5:	e8 b6 c1 ff ff       	call   80100380 <panic>
801041ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041d0 <yield>:
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	53                   	push   %ebx
801041d4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801041d7:	68 20 ad 14 80       	push   $0x8014ad20
801041dc:	e8 9f 05 00 00       	call   80104780 <acquire>
  pushcli();
801041e1:	e8 4a 04 00 00       	call   80104630 <pushcli>
  c = mycpu();
801041e6:	e8 c5 f7 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
801041eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041f1:	e8 8a 04 00 00       	call   80104680 <popcli>
  myproc()->state = RUNNABLE;
801041f6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801041fd:	e8 ae fc ff ff       	call   80103eb0 <sched>
  release(&ptable.lock);
80104202:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80104209:	e8 12 05 00 00       	call   80104720 <release>
}
8010420e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104211:	83 c4 10             	add    $0x10,%esp
80104214:	c9                   	leave  
80104215:	c3                   	ret    
80104216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010421d:	8d 76 00             	lea    0x0(%esi),%esi

80104220 <sleep>:
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	57                   	push   %edi
80104224:	56                   	push   %esi
80104225:	53                   	push   %ebx
80104226:	83 ec 0c             	sub    $0xc,%esp
80104229:	8b 7d 08             	mov    0x8(%ebp),%edi
8010422c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010422f:	e8 fc 03 00 00       	call   80104630 <pushcli>
  c = mycpu();
80104234:	e8 77 f7 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80104239:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010423f:	e8 3c 04 00 00       	call   80104680 <popcli>
  if(p == 0)
80104244:	85 db                	test   %ebx,%ebx
80104246:	0f 84 87 00 00 00    	je     801042d3 <sleep+0xb3>
  if(lk == 0)
8010424c:	85 f6                	test   %esi,%esi
8010424e:	74 76                	je     801042c6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104250:	81 fe 20 ad 14 80    	cmp    $0x8014ad20,%esi
80104256:	74 50                	je     801042a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104258:	83 ec 0c             	sub    $0xc,%esp
8010425b:	68 20 ad 14 80       	push   $0x8014ad20
80104260:	e8 1b 05 00 00       	call   80104780 <acquire>
    release(lk);
80104265:	89 34 24             	mov    %esi,(%esp)
80104268:	e8 b3 04 00 00       	call   80104720 <release>
  p->chan = chan;
8010426d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104270:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104277:	e8 34 fc ff ff       	call   80103eb0 <sched>
  p->chan = 0;
8010427c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104283:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
8010428a:	e8 91 04 00 00       	call   80104720 <release>
    acquire(lk);
8010428f:	89 75 08             	mov    %esi,0x8(%ebp)
80104292:	83 c4 10             	add    $0x10,%esp
}
80104295:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104298:	5b                   	pop    %ebx
80104299:	5e                   	pop    %esi
8010429a:	5f                   	pop    %edi
8010429b:	5d                   	pop    %ebp
    acquire(lk);
8010429c:	e9 df 04 00 00       	jmp    80104780 <acquire>
801042a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801042a8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042b2:	e8 f9 fb ff ff       	call   80103eb0 <sched>
  p->chan = 0;
801042b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042c1:	5b                   	pop    %ebx
801042c2:	5e                   	pop    %esi
801042c3:	5f                   	pop    %edi
801042c4:	5d                   	pop    %ebp
801042c5:	c3                   	ret    
    panic("sleep without lk");
801042c6:	83 ec 0c             	sub    $0xc,%esp
801042c9:	68 9a 7d 10 80       	push   $0x80107d9a
801042ce:	e8 ad c0 ff ff       	call   80100380 <panic>
    panic("sleep");
801042d3:	83 ec 0c             	sub    $0xc,%esp
801042d6:	68 94 7d 10 80       	push   $0x80107d94
801042db:	e8 a0 c0 ff ff       	call   80100380 <panic>

801042e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 10             	sub    $0x10,%esp
801042e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801042ea:	68 20 ad 14 80       	push   $0x8014ad20
801042ef:	e8 8c 04 00 00       	call   80104780 <acquire>
801042f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042f7:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
801042fc:	eb 0c                	jmp    8010430a <wakeup+0x2a>
801042fe:	66 90                	xchg   %ax,%ax
80104300:	83 c0 7c             	add    $0x7c,%eax
80104303:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104308:	74 1c                	je     80104326 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010430a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010430e:	75 f0                	jne    80104300 <wakeup+0x20>
80104310:	3b 58 20             	cmp    0x20(%eax),%ebx
80104313:	75 eb                	jne    80104300 <wakeup+0x20>
      p->state = RUNNABLE;
80104315:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010431c:	83 c0 7c             	add    $0x7c,%eax
8010431f:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104324:	75 e4                	jne    8010430a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104326:	c7 45 08 20 ad 14 80 	movl   $0x8014ad20,0x8(%ebp)
}
8010432d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104330:	c9                   	leave  
  release(&ptable.lock);
80104331:	e9 ea 03 00 00       	jmp    80104720 <release>
80104336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010433d:	8d 76 00             	lea    0x0(%esi),%esi

80104340 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	53                   	push   %ebx
80104344:	83 ec 10             	sub    $0x10,%esp
80104347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010434a:	68 20 ad 14 80       	push   $0x8014ad20
8010434f:	e8 2c 04 00 00       	call   80104780 <acquire>
80104354:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104357:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
8010435c:	eb 0c                	jmp    8010436a <kill+0x2a>
8010435e:	66 90                	xchg   %ax,%ax
80104360:	83 c0 7c             	add    $0x7c,%eax
80104363:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104368:	74 36                	je     801043a0 <kill+0x60>
    if(p->pid == pid){
8010436a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010436d:	75 f1                	jne    80104360 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010436f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104373:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010437a:	75 07                	jne    80104383 <kill+0x43>
        p->state = RUNNABLE;
8010437c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104383:	83 ec 0c             	sub    $0xc,%esp
80104386:	68 20 ad 14 80       	push   $0x8014ad20
8010438b:	e8 90 03 00 00       	call   80104720 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104390:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104393:	83 c4 10             	add    $0x10,%esp
80104396:	31 c0                	xor    %eax,%eax
}
80104398:	c9                   	leave  
80104399:	c3                   	ret    
8010439a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801043a0:	83 ec 0c             	sub    $0xc,%esp
801043a3:	68 20 ad 14 80       	push   $0x8014ad20
801043a8:	e8 73 03 00 00       	call   80104720 <release>
}
801043ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801043b0:	83 c4 10             	add    $0x10,%esp
801043b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043b8:	c9                   	leave  
801043b9:	c3                   	ret    
801043ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	57                   	push   %edi
801043c4:	56                   	push   %esi
801043c5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801043c8:	53                   	push   %ebx
801043c9:	bb c0 ad 14 80       	mov    $0x8014adc0,%ebx
801043ce:	83 ec 3c             	sub    $0x3c,%esp
801043d1:	eb 24                	jmp    801043f7 <procdump+0x37>
801043d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043d7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801043d8:	83 ec 0c             	sub    $0xc,%esp
801043db:	68 b3 81 10 80       	push   $0x801081b3
801043e0:	e8 bb c2 ff ff       	call   801006a0 <cprintf>
801043e5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043e8:	83 c3 7c             	add    $0x7c,%ebx
801043eb:	81 fb c0 cc 14 80    	cmp    $0x8014ccc0,%ebx
801043f1:	0f 84 81 00 00 00    	je     80104478 <procdump+0xb8>
    if(p->state == UNUSED)
801043f7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801043fa:	85 c0                	test   %eax,%eax
801043fc:	74 ea                	je     801043e8 <procdump+0x28>
      state = "???";
801043fe:	ba ab 7d 10 80       	mov    $0x80107dab,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104403:	83 f8 05             	cmp    $0x5,%eax
80104406:	77 11                	ja     80104419 <procdump+0x59>
80104408:	8b 14 85 0c 7e 10 80 	mov    -0x7fef81f4(,%eax,4),%edx
      state = "???";
8010440f:	b8 ab 7d 10 80       	mov    $0x80107dab,%eax
80104414:	85 d2                	test   %edx,%edx
80104416:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104419:	53                   	push   %ebx
8010441a:	52                   	push   %edx
8010441b:	ff 73 a4             	push   -0x5c(%ebx)
8010441e:	68 af 7d 10 80       	push   $0x80107daf
80104423:	e8 78 c2 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104428:	83 c4 10             	add    $0x10,%esp
8010442b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010442f:	75 a7                	jne    801043d8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104431:	83 ec 08             	sub    $0x8,%esp
80104434:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104437:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010443a:	50                   	push   %eax
8010443b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010443e:	8b 40 0c             	mov    0xc(%eax),%eax
80104441:	83 c0 08             	add    $0x8,%eax
80104444:	50                   	push   %eax
80104445:	e8 86 01 00 00       	call   801045d0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010444a:	83 c4 10             	add    $0x10,%esp
8010444d:	8d 76 00             	lea    0x0(%esi),%esi
80104450:	8b 17                	mov    (%edi),%edx
80104452:	85 d2                	test   %edx,%edx
80104454:	74 82                	je     801043d8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104456:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104459:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010445c:	52                   	push   %edx
8010445d:	68 01 78 10 80       	push   $0x80107801
80104462:	e8 39 c2 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104467:	83 c4 10             	add    $0x10,%esp
8010446a:	39 fe                	cmp    %edi,%esi
8010446c:	75 e2                	jne    80104450 <procdump+0x90>
8010446e:	e9 65 ff ff ff       	jmp    801043d8 <procdump+0x18>
80104473:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104477:	90                   	nop
  }
}
80104478:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010447b:	5b                   	pop    %ebx
8010447c:	5e                   	pop    %esi
8010447d:	5f                   	pop    %edi
8010447e:	5d                   	pop    %ebp
8010447f:	c3                   	ret    

80104480 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	53                   	push   %ebx
80104484:	83 ec 0c             	sub    $0xc,%esp
80104487:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010448a:	68 24 7e 10 80       	push   $0x80107e24
8010448f:	8d 43 04             	lea    0x4(%ebx),%eax
80104492:	50                   	push   %eax
80104493:	e8 18 01 00 00       	call   801045b0 <initlock>
  lk->name = name;
80104498:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010449b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801044a1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801044a4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801044ab:	89 43 38             	mov    %eax,0x38(%ebx)
}
801044ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044b1:	c9                   	leave  
801044b2:	c3                   	ret    
801044b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	56                   	push   %esi
801044c4:	53                   	push   %ebx
801044c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044c8:	8d 73 04             	lea    0x4(%ebx),%esi
801044cb:	83 ec 0c             	sub    $0xc,%esp
801044ce:	56                   	push   %esi
801044cf:	e8 ac 02 00 00       	call   80104780 <acquire>
  while (lk->locked) {
801044d4:	8b 13                	mov    (%ebx),%edx
801044d6:	83 c4 10             	add    $0x10,%esp
801044d9:	85 d2                	test   %edx,%edx
801044db:	74 16                	je     801044f3 <acquiresleep+0x33>
801044dd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801044e0:	83 ec 08             	sub    $0x8,%esp
801044e3:	56                   	push   %esi
801044e4:	53                   	push   %ebx
801044e5:	e8 36 fd ff ff       	call   80104220 <sleep>
  while (lk->locked) {
801044ea:	8b 03                	mov    (%ebx),%eax
801044ec:	83 c4 10             	add    $0x10,%esp
801044ef:	85 c0                	test   %eax,%eax
801044f1:	75 ed                	jne    801044e0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801044f3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801044f9:	e8 32 f5 ff ff       	call   80103a30 <myproc>
801044fe:	8b 40 10             	mov    0x10(%eax),%eax
80104501:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104504:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104507:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010450a:	5b                   	pop    %ebx
8010450b:	5e                   	pop    %esi
8010450c:	5d                   	pop    %ebp
  release(&lk->lk);
8010450d:	e9 0e 02 00 00       	jmp    80104720 <release>
80104512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104520 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	56                   	push   %esi
80104524:	53                   	push   %ebx
80104525:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104528:	8d 73 04             	lea    0x4(%ebx),%esi
8010452b:	83 ec 0c             	sub    $0xc,%esp
8010452e:	56                   	push   %esi
8010452f:	e8 4c 02 00 00       	call   80104780 <acquire>
  lk->locked = 0;
80104534:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010453a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104541:	89 1c 24             	mov    %ebx,(%esp)
80104544:	e8 97 fd ff ff       	call   801042e0 <wakeup>
  release(&lk->lk);
80104549:	89 75 08             	mov    %esi,0x8(%ebp)
8010454c:	83 c4 10             	add    $0x10,%esp
}
8010454f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104552:	5b                   	pop    %ebx
80104553:	5e                   	pop    %esi
80104554:	5d                   	pop    %ebp
  release(&lk->lk);
80104555:	e9 c6 01 00 00       	jmp    80104720 <release>
8010455a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104560 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	57                   	push   %edi
80104564:	31 ff                	xor    %edi,%edi
80104566:	56                   	push   %esi
80104567:	53                   	push   %ebx
80104568:	83 ec 18             	sub    $0x18,%esp
8010456b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010456e:	8d 73 04             	lea    0x4(%ebx),%esi
80104571:	56                   	push   %esi
80104572:	e8 09 02 00 00       	call   80104780 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104577:	8b 03                	mov    (%ebx),%eax
80104579:	83 c4 10             	add    $0x10,%esp
8010457c:	85 c0                	test   %eax,%eax
8010457e:	75 18                	jne    80104598 <holdingsleep+0x38>
  release(&lk->lk);
80104580:	83 ec 0c             	sub    $0xc,%esp
80104583:	56                   	push   %esi
80104584:	e8 97 01 00 00       	call   80104720 <release>
  return r;
}
80104589:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010458c:	89 f8                	mov    %edi,%eax
8010458e:	5b                   	pop    %ebx
8010458f:	5e                   	pop    %esi
80104590:	5f                   	pop    %edi
80104591:	5d                   	pop    %ebp
80104592:	c3                   	ret    
80104593:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104597:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104598:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010459b:	e8 90 f4 ff ff       	call   80103a30 <myproc>
801045a0:	39 58 10             	cmp    %ebx,0x10(%eax)
801045a3:	0f 94 c0             	sete   %al
801045a6:	0f b6 c0             	movzbl %al,%eax
801045a9:	89 c7                	mov    %eax,%edi
801045ab:	eb d3                	jmp    80104580 <holdingsleep+0x20>
801045ad:	66 90                	xchg   %ax,%ax
801045af:	90                   	nop

801045b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801045b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801045b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801045bf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801045c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801045c9:	5d                   	pop    %ebp
801045ca:	c3                   	ret    
801045cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045cf:	90                   	nop

801045d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801045d0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801045d1:	31 d2                	xor    %edx,%edx
{
801045d3:	89 e5                	mov    %esp,%ebp
801045d5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801045d6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801045d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801045dc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801045df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045e0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801045e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045ec:	77 1a                	ja     80104608 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801045ee:	8b 58 04             	mov    0x4(%eax),%ebx
801045f1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801045f4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801045f7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801045f9:	83 fa 0a             	cmp    $0xa,%edx
801045fc:	75 e2                	jne    801045e0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801045fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104601:	c9                   	leave  
80104602:	c3                   	ret    
80104603:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104607:	90                   	nop
  for(; i < 10; i++)
80104608:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010460b:	8d 51 28             	lea    0x28(%ecx),%edx
8010460e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104610:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104616:	83 c0 04             	add    $0x4,%eax
80104619:	39 d0                	cmp    %edx,%eax
8010461b:	75 f3                	jne    80104610 <getcallerpcs+0x40>
}
8010461d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104620:	c9                   	leave  
80104621:	c3                   	ret    
80104622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104630 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	53                   	push   %ebx
80104634:	83 ec 04             	sub    $0x4,%esp
80104637:	9c                   	pushf  
80104638:	5b                   	pop    %ebx
  asm volatile("cli");
80104639:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010463a:	e8 71 f3 ff ff       	call   801039b0 <mycpu>
8010463f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104645:	85 c0                	test   %eax,%eax
80104647:	74 17                	je     80104660 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104649:	e8 62 f3 ff ff       	call   801039b0 <mycpu>
8010464e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104655:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104658:	c9                   	leave  
80104659:	c3                   	ret    
8010465a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104660:	e8 4b f3 ff ff       	call   801039b0 <mycpu>
80104665:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010466b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104671:	eb d6                	jmp    80104649 <pushcli+0x19>
80104673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104680 <popcli>:

void
popcli(void)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104686:	9c                   	pushf  
80104687:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104688:	f6 c4 02             	test   $0x2,%ah
8010468b:	75 35                	jne    801046c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010468d:	e8 1e f3 ff ff       	call   801039b0 <mycpu>
80104692:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104699:	78 34                	js     801046cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010469b:	e8 10 f3 ff ff       	call   801039b0 <mycpu>
801046a0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801046a6:	85 d2                	test   %edx,%edx
801046a8:	74 06                	je     801046b0 <popcli+0x30>
    sti();
}
801046aa:	c9                   	leave  
801046ab:	c3                   	ret    
801046ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046b0:	e8 fb f2 ff ff       	call   801039b0 <mycpu>
801046b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801046bb:	85 c0                	test   %eax,%eax
801046bd:	74 eb                	je     801046aa <popcli+0x2a>
  asm volatile("sti");
801046bf:	fb                   	sti    
}
801046c0:	c9                   	leave  
801046c1:	c3                   	ret    
    panic("popcli - interruptible");
801046c2:	83 ec 0c             	sub    $0xc,%esp
801046c5:	68 2f 7e 10 80       	push   $0x80107e2f
801046ca:	e8 b1 bc ff ff       	call   80100380 <panic>
    panic("popcli");
801046cf:	83 ec 0c             	sub    $0xc,%esp
801046d2:	68 46 7e 10 80       	push   $0x80107e46
801046d7:	e8 a4 bc ff ff       	call   80100380 <panic>
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046e0 <holding>:
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	56                   	push   %esi
801046e4:	53                   	push   %ebx
801046e5:	8b 75 08             	mov    0x8(%ebp),%esi
801046e8:	31 db                	xor    %ebx,%ebx
  pushcli();
801046ea:	e8 41 ff ff ff       	call   80104630 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046ef:	8b 06                	mov    (%esi),%eax
801046f1:	85 c0                	test   %eax,%eax
801046f3:	75 0b                	jne    80104700 <holding+0x20>
  popcli();
801046f5:	e8 86 ff ff ff       	call   80104680 <popcli>
}
801046fa:	89 d8                	mov    %ebx,%eax
801046fc:	5b                   	pop    %ebx
801046fd:	5e                   	pop    %esi
801046fe:	5d                   	pop    %ebp
801046ff:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104700:	8b 5e 08             	mov    0x8(%esi),%ebx
80104703:	e8 a8 f2 ff ff       	call   801039b0 <mycpu>
80104708:	39 c3                	cmp    %eax,%ebx
8010470a:	0f 94 c3             	sete   %bl
  popcli();
8010470d:	e8 6e ff ff ff       	call   80104680 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104712:	0f b6 db             	movzbl %bl,%ebx
}
80104715:	89 d8                	mov    %ebx,%eax
80104717:	5b                   	pop    %ebx
80104718:	5e                   	pop    %esi
80104719:	5d                   	pop    %ebp
8010471a:	c3                   	ret    
8010471b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010471f:	90                   	nop

80104720 <release>:
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	56                   	push   %esi
80104724:	53                   	push   %ebx
80104725:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104728:	e8 03 ff ff ff       	call   80104630 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010472d:	8b 03                	mov    (%ebx),%eax
8010472f:	85 c0                	test   %eax,%eax
80104731:	75 15                	jne    80104748 <release+0x28>
  popcli();
80104733:	e8 48 ff ff ff       	call   80104680 <popcli>
    panic("release");
80104738:	83 ec 0c             	sub    $0xc,%esp
8010473b:	68 4d 7e 10 80       	push   $0x80107e4d
80104740:	e8 3b bc ff ff       	call   80100380 <panic>
80104745:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104748:	8b 73 08             	mov    0x8(%ebx),%esi
8010474b:	e8 60 f2 ff ff       	call   801039b0 <mycpu>
80104750:	39 c6                	cmp    %eax,%esi
80104752:	75 df                	jne    80104733 <release+0x13>
  popcli();
80104754:	e8 27 ff ff ff       	call   80104680 <popcli>
  lk->pcs[0] = 0;
80104759:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104760:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104767:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010476c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104772:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104775:	5b                   	pop    %ebx
80104776:	5e                   	pop    %esi
80104777:	5d                   	pop    %ebp
  popcli();
80104778:	e9 03 ff ff ff       	jmp    80104680 <popcli>
8010477d:	8d 76 00             	lea    0x0(%esi),%esi

80104780 <acquire>:
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	53                   	push   %ebx
80104784:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104787:	e8 a4 fe ff ff       	call   80104630 <pushcli>
  if(holding(lk))
8010478c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010478f:	e8 9c fe ff ff       	call   80104630 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104794:	8b 03                	mov    (%ebx),%eax
80104796:	85 c0                	test   %eax,%eax
80104798:	75 7e                	jne    80104818 <acquire+0x98>
  popcli();
8010479a:	e8 e1 fe ff ff       	call   80104680 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010479f:	b9 01 00 00 00       	mov    $0x1,%ecx
801047a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801047a8:	8b 55 08             	mov    0x8(%ebp),%edx
801047ab:	89 c8                	mov    %ecx,%eax
801047ad:	f0 87 02             	lock xchg %eax,(%edx)
801047b0:	85 c0                	test   %eax,%eax
801047b2:	75 f4                	jne    801047a8 <acquire+0x28>
  __sync_synchronize();
801047b4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047bc:	e8 ef f1 ff ff       	call   801039b0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801047c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801047c4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801047c6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801047c9:	31 c0                	xor    %eax,%eax
801047cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047cf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047d0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801047d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047dc:	77 1a                	ja     801047f8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801047de:	8b 5a 04             	mov    0x4(%edx),%ebx
801047e1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801047e5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801047e8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801047ea:	83 f8 0a             	cmp    $0xa,%eax
801047ed:	75 e1                	jne    801047d0 <acquire+0x50>
}
801047ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047f2:	c9                   	leave  
801047f3:	c3                   	ret    
801047f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801047f8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801047fc:	8d 51 34             	lea    0x34(%ecx),%edx
801047ff:	90                   	nop
    pcs[i] = 0;
80104800:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104806:	83 c0 04             	add    $0x4,%eax
80104809:	39 c2                	cmp    %eax,%edx
8010480b:	75 f3                	jne    80104800 <acquire+0x80>
}
8010480d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104810:	c9                   	leave  
80104811:	c3                   	ret    
80104812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104818:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010481b:	e8 90 f1 ff ff       	call   801039b0 <mycpu>
80104820:	39 c3                	cmp    %eax,%ebx
80104822:	0f 85 72 ff ff ff    	jne    8010479a <acquire+0x1a>
  popcli();
80104828:	e8 53 fe ff ff       	call   80104680 <popcli>
    panic("acquire");
8010482d:	83 ec 0c             	sub    $0xc,%esp
80104830:	68 55 7e 10 80       	push   $0x80107e55
80104835:	e8 46 bb ff ff       	call   80100380 <panic>
8010483a:	66 90                	xchg   %ax,%ax
8010483c:	66 90                	xchg   %ax,%ax
8010483e:	66 90                	xchg   %ax,%ax

80104840 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	57                   	push   %edi
80104844:	8b 55 08             	mov    0x8(%ebp),%edx
80104847:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010484a:	53                   	push   %ebx
8010484b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010484e:	89 d7                	mov    %edx,%edi
80104850:	09 cf                	or     %ecx,%edi
80104852:	83 e7 03             	and    $0x3,%edi
80104855:	75 29                	jne    80104880 <memset+0x40>
    c &= 0xFF;
80104857:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010485a:	c1 e0 18             	shl    $0x18,%eax
8010485d:	89 fb                	mov    %edi,%ebx
8010485f:	c1 e9 02             	shr    $0x2,%ecx
80104862:	c1 e3 10             	shl    $0x10,%ebx
80104865:	09 d8                	or     %ebx,%eax
80104867:	09 f8                	or     %edi,%eax
80104869:	c1 e7 08             	shl    $0x8,%edi
8010486c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010486e:	89 d7                	mov    %edx,%edi
80104870:	fc                   	cld    
80104871:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104873:	5b                   	pop    %ebx
80104874:	89 d0                	mov    %edx,%eax
80104876:	5f                   	pop    %edi
80104877:	5d                   	pop    %ebp
80104878:	c3                   	ret    
80104879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104880:	89 d7                	mov    %edx,%edi
80104882:	fc                   	cld    
80104883:	f3 aa                	rep stos %al,%es:(%edi)
80104885:	5b                   	pop    %ebx
80104886:	89 d0                	mov    %edx,%eax
80104888:	5f                   	pop    %edi
80104889:	5d                   	pop    %ebp
8010488a:	c3                   	ret    
8010488b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010488f:	90                   	nop

80104890 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	8b 75 10             	mov    0x10(%ebp),%esi
80104897:	8b 55 08             	mov    0x8(%ebp),%edx
8010489a:	53                   	push   %ebx
8010489b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010489e:	85 f6                	test   %esi,%esi
801048a0:	74 2e                	je     801048d0 <memcmp+0x40>
801048a2:	01 c6                	add    %eax,%esi
801048a4:	eb 14                	jmp    801048ba <memcmp+0x2a>
801048a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ad:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801048b0:	83 c0 01             	add    $0x1,%eax
801048b3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801048b6:	39 f0                	cmp    %esi,%eax
801048b8:	74 16                	je     801048d0 <memcmp+0x40>
    if(*s1 != *s2)
801048ba:	0f b6 0a             	movzbl (%edx),%ecx
801048bd:	0f b6 18             	movzbl (%eax),%ebx
801048c0:	38 d9                	cmp    %bl,%cl
801048c2:	74 ec                	je     801048b0 <memcmp+0x20>
      return *s1 - *s2;
801048c4:	0f b6 c1             	movzbl %cl,%eax
801048c7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801048c9:	5b                   	pop    %ebx
801048ca:	5e                   	pop    %esi
801048cb:	5d                   	pop    %ebp
801048cc:	c3                   	ret    
801048cd:	8d 76 00             	lea    0x0(%esi),%esi
801048d0:	5b                   	pop    %ebx
  return 0;
801048d1:	31 c0                	xor    %eax,%eax
}
801048d3:	5e                   	pop    %esi
801048d4:	5d                   	pop    %ebp
801048d5:	c3                   	ret    
801048d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048dd:	8d 76 00             	lea    0x0(%esi),%esi

801048e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	57                   	push   %edi
801048e4:	8b 55 08             	mov    0x8(%ebp),%edx
801048e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048ea:	56                   	push   %esi
801048eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801048ee:	39 d6                	cmp    %edx,%esi
801048f0:	73 26                	jae    80104918 <memmove+0x38>
801048f2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801048f5:	39 fa                	cmp    %edi,%edx
801048f7:	73 1f                	jae    80104918 <memmove+0x38>
801048f9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801048fc:	85 c9                	test   %ecx,%ecx
801048fe:	74 0c                	je     8010490c <memmove+0x2c>
      *--d = *--s;
80104900:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104904:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104907:	83 e8 01             	sub    $0x1,%eax
8010490a:	73 f4                	jae    80104900 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010490c:	5e                   	pop    %esi
8010490d:	89 d0                	mov    %edx,%eax
8010490f:	5f                   	pop    %edi
80104910:	5d                   	pop    %ebp
80104911:	c3                   	ret    
80104912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104918:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010491b:	89 d7                	mov    %edx,%edi
8010491d:	85 c9                	test   %ecx,%ecx
8010491f:	74 eb                	je     8010490c <memmove+0x2c>
80104921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104928:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104929:	39 c6                	cmp    %eax,%esi
8010492b:	75 fb                	jne    80104928 <memmove+0x48>
}
8010492d:	5e                   	pop    %esi
8010492e:	89 d0                	mov    %edx,%eax
80104930:	5f                   	pop    %edi
80104931:	5d                   	pop    %ebp
80104932:	c3                   	ret    
80104933:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104940 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104940:	eb 9e                	jmp    801048e0 <memmove>
80104942:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104950 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	56                   	push   %esi
80104954:	8b 75 10             	mov    0x10(%ebp),%esi
80104957:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010495a:	53                   	push   %ebx
8010495b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010495e:	85 f6                	test   %esi,%esi
80104960:	74 2e                	je     80104990 <strncmp+0x40>
80104962:	01 d6                	add    %edx,%esi
80104964:	eb 18                	jmp    8010497e <strncmp+0x2e>
80104966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496d:	8d 76 00             	lea    0x0(%esi),%esi
80104970:	38 d8                	cmp    %bl,%al
80104972:	75 14                	jne    80104988 <strncmp+0x38>
    n--, p++, q++;
80104974:	83 c2 01             	add    $0x1,%edx
80104977:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010497a:	39 f2                	cmp    %esi,%edx
8010497c:	74 12                	je     80104990 <strncmp+0x40>
8010497e:	0f b6 01             	movzbl (%ecx),%eax
80104981:	0f b6 1a             	movzbl (%edx),%ebx
80104984:	84 c0                	test   %al,%al
80104986:	75 e8                	jne    80104970 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104988:	29 d8                	sub    %ebx,%eax
}
8010498a:	5b                   	pop    %ebx
8010498b:	5e                   	pop    %esi
8010498c:	5d                   	pop    %ebp
8010498d:	c3                   	ret    
8010498e:	66 90                	xchg   %ax,%ax
80104990:	5b                   	pop    %ebx
    return 0;
80104991:	31 c0                	xor    %eax,%eax
}
80104993:	5e                   	pop    %esi
80104994:	5d                   	pop    %ebp
80104995:	c3                   	ret    
80104996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499d:	8d 76 00             	lea    0x0(%esi),%esi

801049a0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	57                   	push   %edi
801049a4:	56                   	push   %esi
801049a5:	8b 75 08             	mov    0x8(%ebp),%esi
801049a8:	53                   	push   %ebx
801049a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801049ac:	89 f0                	mov    %esi,%eax
801049ae:	eb 15                	jmp    801049c5 <strncpy+0x25>
801049b0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801049b4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801049b7:	83 c0 01             	add    $0x1,%eax
801049ba:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
801049be:	88 50 ff             	mov    %dl,-0x1(%eax)
801049c1:	84 d2                	test   %dl,%dl
801049c3:	74 09                	je     801049ce <strncpy+0x2e>
801049c5:	89 cb                	mov    %ecx,%ebx
801049c7:	83 e9 01             	sub    $0x1,%ecx
801049ca:	85 db                	test   %ebx,%ebx
801049cc:	7f e2                	jg     801049b0 <strncpy+0x10>
    ;
  while(n-- > 0)
801049ce:	89 c2                	mov    %eax,%edx
801049d0:	85 c9                	test   %ecx,%ecx
801049d2:	7e 17                	jle    801049eb <strncpy+0x4b>
801049d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801049d8:	83 c2 01             	add    $0x1,%edx
801049db:	89 c1                	mov    %eax,%ecx
801049dd:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
801049e1:	29 d1                	sub    %edx,%ecx
801049e3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
801049e7:	85 c9                	test   %ecx,%ecx
801049e9:	7f ed                	jg     801049d8 <strncpy+0x38>
  return os;
}
801049eb:	5b                   	pop    %ebx
801049ec:	89 f0                	mov    %esi,%eax
801049ee:	5e                   	pop    %esi
801049ef:	5f                   	pop    %edi
801049f0:	5d                   	pop    %ebp
801049f1:	c3                   	ret    
801049f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	56                   	push   %esi
80104a04:	8b 55 10             	mov    0x10(%ebp),%edx
80104a07:	8b 75 08             	mov    0x8(%ebp),%esi
80104a0a:	53                   	push   %ebx
80104a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a0e:	85 d2                	test   %edx,%edx
80104a10:	7e 25                	jle    80104a37 <safestrcpy+0x37>
80104a12:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a16:	89 f2                	mov    %esi,%edx
80104a18:	eb 16                	jmp    80104a30 <safestrcpy+0x30>
80104a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a20:	0f b6 08             	movzbl (%eax),%ecx
80104a23:	83 c0 01             	add    $0x1,%eax
80104a26:	83 c2 01             	add    $0x1,%edx
80104a29:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a2c:	84 c9                	test   %cl,%cl
80104a2e:	74 04                	je     80104a34 <safestrcpy+0x34>
80104a30:	39 d8                	cmp    %ebx,%eax
80104a32:	75 ec                	jne    80104a20 <safestrcpy+0x20>
    ;
  *s = 0;
80104a34:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a37:	89 f0                	mov    %esi,%eax
80104a39:	5b                   	pop    %ebx
80104a3a:	5e                   	pop    %esi
80104a3b:	5d                   	pop    %ebp
80104a3c:	c3                   	ret    
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi

80104a40 <strlen>:

int
strlen(const char *s)
{
80104a40:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a41:	31 c0                	xor    %eax,%eax
{
80104a43:	89 e5                	mov    %esp,%ebp
80104a45:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a48:	80 3a 00             	cmpb   $0x0,(%edx)
80104a4b:	74 0c                	je     80104a59 <strlen+0x19>
80104a4d:	8d 76 00             	lea    0x0(%esi),%esi
80104a50:	83 c0 01             	add    $0x1,%eax
80104a53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a57:	75 f7                	jne    80104a50 <strlen+0x10>
    ;
  return n;
}
80104a59:	5d                   	pop    %ebp
80104a5a:	c3                   	ret    

80104a5b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a5b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a5f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a63:	55                   	push   %ebp
  pushl %ebx
80104a64:	53                   	push   %ebx
  pushl %esi
80104a65:	56                   	push   %esi
  pushl %edi
80104a66:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a67:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a69:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a6b:	5f                   	pop    %edi
  popl %esi
80104a6c:	5e                   	pop    %esi
  popl %ebx
80104a6d:	5b                   	pop    %ebx
  popl %ebp
80104a6e:	5d                   	pop    %ebp
  ret
80104a6f:	c3                   	ret    

80104a70 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	53                   	push   %ebx
80104a74:	83 ec 04             	sub    $0x4,%esp
80104a77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a7a:	e8 b1 ef ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a7f:	8b 00                	mov    (%eax),%eax
80104a81:	39 d8                	cmp    %ebx,%eax
80104a83:	76 1b                	jbe    80104aa0 <fetchint+0x30>
80104a85:	8d 53 04             	lea    0x4(%ebx),%edx
80104a88:	39 d0                	cmp    %edx,%eax
80104a8a:	72 14                	jb     80104aa0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a8f:	8b 13                	mov    (%ebx),%edx
80104a91:	89 10                	mov    %edx,(%eax)
  return 0;
80104a93:	31 c0                	xor    %eax,%eax
}
80104a95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a98:	c9                   	leave  
80104a99:	c3                   	ret    
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aa5:	eb ee                	jmp    80104a95 <fetchint+0x25>
80104aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aae:	66 90                	xchg   %ax,%ax

80104ab0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	53                   	push   %ebx
80104ab4:	83 ec 04             	sub    $0x4,%esp
80104ab7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104aba:	e8 71 ef ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->sz)
80104abf:	39 18                	cmp    %ebx,(%eax)
80104ac1:	76 2d                	jbe    80104af0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ac6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ac8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104aca:	39 d3                	cmp    %edx,%ebx
80104acc:	73 22                	jae    80104af0 <fetchstr+0x40>
80104ace:	89 d8                	mov    %ebx,%eax
80104ad0:	eb 0d                	jmp    80104adf <fetchstr+0x2f>
80104ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ad8:	83 c0 01             	add    $0x1,%eax
80104adb:	39 c2                	cmp    %eax,%edx
80104add:	76 11                	jbe    80104af0 <fetchstr+0x40>
    if(*s == 0)
80104adf:	80 38 00             	cmpb   $0x0,(%eax)
80104ae2:	75 f4                	jne    80104ad8 <fetchstr+0x28>
      return s - *pp;
80104ae4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104ae6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ae9:	c9                   	leave  
80104aea:	c3                   	ret    
80104aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aef:	90                   	nop
80104af0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104af3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104af8:	c9                   	leave  
80104af9:	c3                   	ret    
80104afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b00 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	56                   	push   %esi
80104b04:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b05:	e8 26 ef ff ff       	call   80103a30 <myproc>
80104b0a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b0d:	8b 40 18             	mov    0x18(%eax),%eax
80104b10:	8b 40 44             	mov    0x44(%eax),%eax
80104b13:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b16:	e8 15 ef ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b1b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b1e:	8b 00                	mov    (%eax),%eax
80104b20:	39 c6                	cmp    %eax,%esi
80104b22:	73 1c                	jae    80104b40 <argint+0x40>
80104b24:	8d 53 08             	lea    0x8(%ebx),%edx
80104b27:	39 d0                	cmp    %edx,%eax
80104b29:	72 15                	jb     80104b40 <argint+0x40>
  *ip = *(int*)(addr);
80104b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b2e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b31:	89 10                	mov    %edx,(%eax)
  return 0;
80104b33:	31 c0                	xor    %eax,%eax
}
80104b35:	5b                   	pop    %ebx
80104b36:	5e                   	pop    %esi
80104b37:	5d                   	pop    %ebp
80104b38:	c3                   	ret    
80104b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b45:	eb ee                	jmp    80104b35 <argint+0x35>
80104b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b4e:	66 90                	xchg   %ax,%ax

80104b50 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	57                   	push   %edi
80104b54:	56                   	push   %esi
80104b55:	53                   	push   %ebx
80104b56:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104b59:	e8 d2 ee ff ff       	call   80103a30 <myproc>
80104b5e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b60:	e8 cb ee ff ff       	call   80103a30 <myproc>
80104b65:	8b 55 08             	mov    0x8(%ebp),%edx
80104b68:	8b 40 18             	mov    0x18(%eax),%eax
80104b6b:	8b 40 44             	mov    0x44(%eax),%eax
80104b6e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b71:	e8 ba ee ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b76:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b79:	8b 00                	mov    (%eax),%eax
80104b7b:	39 c7                	cmp    %eax,%edi
80104b7d:	73 31                	jae    80104bb0 <argptr+0x60>
80104b7f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104b82:	39 c8                	cmp    %ecx,%eax
80104b84:	72 2a                	jb     80104bb0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b86:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104b89:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b8c:	85 d2                	test   %edx,%edx
80104b8e:	78 20                	js     80104bb0 <argptr+0x60>
80104b90:	8b 16                	mov    (%esi),%edx
80104b92:	39 c2                	cmp    %eax,%edx
80104b94:	76 1a                	jbe    80104bb0 <argptr+0x60>
80104b96:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b99:	01 c3                	add    %eax,%ebx
80104b9b:	39 da                	cmp    %ebx,%edx
80104b9d:	72 11                	jb     80104bb0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ba2:	89 02                	mov    %eax,(%edx)
  return 0;
80104ba4:	31 c0                	xor    %eax,%eax
}
80104ba6:	83 c4 0c             	add    $0xc,%esp
80104ba9:	5b                   	pop    %ebx
80104baa:	5e                   	pop    %esi
80104bab:	5f                   	pop    %edi
80104bac:	5d                   	pop    %ebp
80104bad:	c3                   	ret    
80104bae:	66 90                	xchg   %ax,%ax
    return -1;
80104bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bb5:	eb ef                	jmp    80104ba6 <argptr+0x56>
80104bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bbe:	66 90                	xchg   %ax,%ax

80104bc0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bc5:	e8 66 ee ff ff       	call   80103a30 <myproc>
80104bca:	8b 55 08             	mov    0x8(%ebp),%edx
80104bcd:	8b 40 18             	mov    0x18(%eax),%eax
80104bd0:	8b 40 44             	mov    0x44(%eax),%eax
80104bd3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bd6:	e8 55 ee ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bdb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bde:	8b 00                	mov    (%eax),%eax
80104be0:	39 c6                	cmp    %eax,%esi
80104be2:	73 44                	jae    80104c28 <argstr+0x68>
80104be4:	8d 53 08             	lea    0x8(%ebx),%edx
80104be7:	39 d0                	cmp    %edx,%eax
80104be9:	72 3d                	jb     80104c28 <argstr+0x68>
  *ip = *(int*)(addr);
80104beb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104bee:	e8 3d ee ff ff       	call   80103a30 <myproc>
  if(addr >= curproc->sz)
80104bf3:	3b 18                	cmp    (%eax),%ebx
80104bf5:	73 31                	jae    80104c28 <argstr+0x68>
  *pp = (char*)addr;
80104bf7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bfa:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104bfc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104bfe:	39 d3                	cmp    %edx,%ebx
80104c00:	73 26                	jae    80104c28 <argstr+0x68>
80104c02:	89 d8                	mov    %ebx,%eax
80104c04:	eb 11                	jmp    80104c17 <argstr+0x57>
80104c06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c0d:	8d 76 00             	lea    0x0(%esi),%esi
80104c10:	83 c0 01             	add    $0x1,%eax
80104c13:	39 c2                	cmp    %eax,%edx
80104c15:	76 11                	jbe    80104c28 <argstr+0x68>
    if(*s == 0)
80104c17:	80 38 00             	cmpb   $0x0,(%eax)
80104c1a:	75 f4                	jne    80104c10 <argstr+0x50>
      return s - *pp;
80104c1c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c1e:	5b                   	pop    %ebx
80104c1f:	5e                   	pop    %esi
80104c20:	5d                   	pop    %ebp
80104c21:	c3                   	ret    
80104c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c28:	5b                   	pop    %ebx
    return -1;
80104c29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c2e:	5e                   	pop    %esi
80104c2f:	5d                   	pop    %ebp
80104c30:	c3                   	ret    
80104c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3f:	90                   	nop

80104c40 <syscall>:
[SYS_forkcow]  sys_forkcow,
};

void
syscall(void)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	53                   	push   %ebx
80104c44:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c47:	e8 e4 ed ff ff       	call   80103a30 <myproc>
80104c4c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c4e:	8b 40 18             	mov    0x18(%eax),%eax
80104c51:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c54:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c57:	83 fa 18             	cmp    $0x18,%edx
80104c5a:	77 24                	ja     80104c80 <syscall+0x40>
80104c5c:	8b 14 85 80 7e 10 80 	mov    -0x7fef8180(,%eax,4),%edx
80104c63:	85 d2                	test   %edx,%edx
80104c65:	74 19                	je     80104c80 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c67:	ff d2                	call   *%edx
80104c69:	89 c2                	mov    %eax,%edx
80104c6b:	8b 43 18             	mov    0x18(%ebx),%eax
80104c6e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c74:	c9                   	leave  
80104c75:	c3                   	ret    
80104c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104c80:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c81:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c84:	50                   	push   %eax
80104c85:	ff 73 10             	push   0x10(%ebx)
80104c88:	68 5d 7e 10 80       	push   $0x80107e5d
80104c8d:	e8 0e ba ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104c92:	8b 43 18             	mov    0x18(%ebx),%eax
80104c95:	83 c4 10             	add    $0x10,%esp
80104c98:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca2:	c9                   	leave  
80104ca3:	c3                   	ret    
80104ca4:	66 90                	xchg   %ax,%ax
80104ca6:	66 90                	xchg   %ax,%ax
80104ca8:	66 90                	xchg   %ax,%ax
80104caa:	66 90                	xchg   %ax,%ax
80104cac:	66 90                	xchg   %ax,%ax
80104cae:	66 90                	xchg   %ax,%ax

80104cb0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	57                   	push   %edi
80104cb4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104cb5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104cb8:	53                   	push   %ebx
80104cb9:	83 ec 34             	sub    $0x34,%esp
80104cbc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104cbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104cc2:	57                   	push   %edi
80104cc3:	50                   	push   %eax
{
80104cc4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104cc7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104cca:	e8 f1 d3 ff ff       	call   801020c0 <nameiparent>
80104ccf:	83 c4 10             	add    $0x10,%esp
80104cd2:	85 c0                	test   %eax,%eax
80104cd4:	0f 84 46 01 00 00    	je     80104e20 <create+0x170>
    return 0;
  ilock(dp);
80104cda:	83 ec 0c             	sub    $0xc,%esp
80104cdd:	89 c3                	mov    %eax,%ebx
80104cdf:	50                   	push   %eax
80104ce0:	e8 9b ca ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104ce5:	83 c4 0c             	add    $0xc,%esp
80104ce8:	6a 00                	push   $0x0
80104cea:	57                   	push   %edi
80104ceb:	53                   	push   %ebx
80104cec:	e8 ef cf ff ff       	call   80101ce0 <dirlookup>
80104cf1:	83 c4 10             	add    $0x10,%esp
80104cf4:	89 c6                	mov    %eax,%esi
80104cf6:	85 c0                	test   %eax,%eax
80104cf8:	74 56                	je     80104d50 <create+0xa0>
    iunlockput(dp);
80104cfa:	83 ec 0c             	sub    $0xc,%esp
80104cfd:	53                   	push   %ebx
80104cfe:	e8 0d cd ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104d03:	89 34 24             	mov    %esi,(%esp)
80104d06:	e8 75 ca ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d0b:	83 c4 10             	add    $0x10,%esp
80104d0e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d13:	75 1b                	jne    80104d30 <create+0x80>
80104d15:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d1a:	75 14                	jne    80104d30 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d1f:	89 f0                	mov    %esi,%eax
80104d21:	5b                   	pop    %ebx
80104d22:	5e                   	pop    %esi
80104d23:	5f                   	pop    %edi
80104d24:	5d                   	pop    %ebp
80104d25:	c3                   	ret    
80104d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d30:	83 ec 0c             	sub    $0xc,%esp
80104d33:	56                   	push   %esi
    return 0;
80104d34:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104d36:	e8 d5 cc ff ff       	call   80101a10 <iunlockput>
    return 0;
80104d3b:	83 c4 10             	add    $0x10,%esp
}
80104d3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d41:	89 f0                	mov    %esi,%eax
80104d43:	5b                   	pop    %ebx
80104d44:	5e                   	pop    %esi
80104d45:	5f                   	pop    %edi
80104d46:	5d                   	pop    %ebp
80104d47:	c3                   	ret    
80104d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104d50:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d54:	83 ec 08             	sub    $0x8,%esp
80104d57:	50                   	push   %eax
80104d58:	ff 33                	push   (%ebx)
80104d5a:	e8 b1 c8 ff ff       	call   80101610 <ialloc>
80104d5f:	83 c4 10             	add    $0x10,%esp
80104d62:	89 c6                	mov    %eax,%esi
80104d64:	85 c0                	test   %eax,%eax
80104d66:	0f 84 cd 00 00 00    	je     80104e39 <create+0x189>
  ilock(ip);
80104d6c:	83 ec 0c             	sub    $0xc,%esp
80104d6f:	50                   	push   %eax
80104d70:	e8 0b ca ff ff       	call   80101780 <ilock>
  ip->major = major;
80104d75:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d79:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d7d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d81:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104d85:	b8 01 00 00 00       	mov    $0x1,%eax
80104d8a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104d8e:	89 34 24             	mov    %esi,(%esp)
80104d91:	e8 3a c9 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d96:	83 c4 10             	add    $0x10,%esp
80104d99:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d9e:	74 30                	je     80104dd0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104da0:	83 ec 04             	sub    $0x4,%esp
80104da3:	ff 76 04             	push   0x4(%esi)
80104da6:	57                   	push   %edi
80104da7:	53                   	push   %ebx
80104da8:	e8 33 d2 ff ff       	call   80101fe0 <dirlink>
80104dad:	83 c4 10             	add    $0x10,%esp
80104db0:	85 c0                	test   %eax,%eax
80104db2:	78 78                	js     80104e2c <create+0x17c>
  iunlockput(dp);
80104db4:	83 ec 0c             	sub    $0xc,%esp
80104db7:	53                   	push   %ebx
80104db8:	e8 53 cc ff ff       	call   80101a10 <iunlockput>
  return ip;
80104dbd:	83 c4 10             	add    $0x10,%esp
}
80104dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dc3:	89 f0                	mov    %esi,%eax
80104dc5:	5b                   	pop    %ebx
80104dc6:	5e                   	pop    %esi
80104dc7:	5f                   	pop    %edi
80104dc8:	5d                   	pop    %ebp
80104dc9:	c3                   	ret    
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104dd0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104dd3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104dd8:	53                   	push   %ebx
80104dd9:	e8 f2 c8 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104dde:	83 c4 0c             	add    $0xc,%esp
80104de1:	ff 76 04             	push   0x4(%esi)
80104de4:	68 04 7f 10 80       	push   $0x80107f04
80104de9:	56                   	push   %esi
80104dea:	e8 f1 d1 ff ff       	call   80101fe0 <dirlink>
80104def:	83 c4 10             	add    $0x10,%esp
80104df2:	85 c0                	test   %eax,%eax
80104df4:	78 18                	js     80104e0e <create+0x15e>
80104df6:	83 ec 04             	sub    $0x4,%esp
80104df9:	ff 73 04             	push   0x4(%ebx)
80104dfc:	68 03 7f 10 80       	push   $0x80107f03
80104e01:	56                   	push   %esi
80104e02:	e8 d9 d1 ff ff       	call   80101fe0 <dirlink>
80104e07:	83 c4 10             	add    $0x10,%esp
80104e0a:	85 c0                	test   %eax,%eax
80104e0c:	79 92                	jns    80104da0 <create+0xf0>
      panic("create dots");
80104e0e:	83 ec 0c             	sub    $0xc,%esp
80104e11:	68 f7 7e 10 80       	push   $0x80107ef7
80104e16:	e8 65 b5 ff ff       	call   80100380 <panic>
80104e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e1f:	90                   	nop
}
80104e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e23:	31 f6                	xor    %esi,%esi
}
80104e25:	5b                   	pop    %ebx
80104e26:	89 f0                	mov    %esi,%eax
80104e28:	5e                   	pop    %esi
80104e29:	5f                   	pop    %edi
80104e2a:	5d                   	pop    %ebp
80104e2b:	c3                   	ret    
    panic("create: dirlink");
80104e2c:	83 ec 0c             	sub    $0xc,%esp
80104e2f:	68 06 7f 10 80       	push   $0x80107f06
80104e34:	e8 47 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e39:	83 ec 0c             	sub    $0xc,%esp
80104e3c:	68 e8 7e 10 80       	push   $0x80107ee8
80104e41:	e8 3a b5 ff ff       	call   80100380 <panic>
80104e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e4d:	8d 76 00             	lea    0x0(%esi),%esi

80104e50 <sys_dup>:
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	56                   	push   %esi
80104e54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e55:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e5b:	50                   	push   %eax
80104e5c:	6a 00                	push   $0x0
80104e5e:	e8 9d fc ff ff       	call   80104b00 <argint>
80104e63:	83 c4 10             	add    $0x10,%esp
80104e66:	85 c0                	test   %eax,%eax
80104e68:	78 36                	js     80104ea0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e6e:	77 30                	ja     80104ea0 <sys_dup+0x50>
80104e70:	e8 bb eb ff ff       	call   80103a30 <myproc>
80104e75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e78:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e7c:	85 f6                	test   %esi,%esi
80104e7e:	74 20                	je     80104ea0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104e80:	e8 ab eb ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e85:	31 db                	xor    %ebx,%ebx
80104e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e8e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104e90:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e94:	85 d2                	test   %edx,%edx
80104e96:	74 18                	je     80104eb0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104e98:	83 c3 01             	add    $0x1,%ebx
80104e9b:	83 fb 10             	cmp    $0x10,%ebx
80104e9e:	75 f0                	jne    80104e90 <sys_dup+0x40>
}
80104ea0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104ea3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ea8:	89 d8                	mov    %ebx,%eax
80104eaa:	5b                   	pop    %ebx
80104eab:	5e                   	pop    %esi
80104eac:	5d                   	pop    %ebp
80104ead:	c3                   	ret    
80104eae:	66 90                	xchg   %ax,%ax
  filedup(f);
80104eb0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104eb3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104eb7:	56                   	push   %esi
80104eb8:	e8 e3 bf ff ff       	call   80100ea0 <filedup>
  return fd;
80104ebd:	83 c4 10             	add    $0x10,%esp
}
80104ec0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ec3:	89 d8                	mov    %ebx,%eax
80104ec5:	5b                   	pop    %ebx
80104ec6:	5e                   	pop    %esi
80104ec7:	5d                   	pop    %ebp
80104ec8:	c3                   	ret    
80104ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ed0 <sys_read>:
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	56                   	push   %esi
80104ed4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ed5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ed8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104edb:	53                   	push   %ebx
80104edc:	6a 00                	push   $0x0
80104ede:	e8 1d fc ff ff       	call   80104b00 <argint>
80104ee3:	83 c4 10             	add    $0x10,%esp
80104ee6:	85 c0                	test   %eax,%eax
80104ee8:	78 5e                	js     80104f48 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104eee:	77 58                	ja     80104f48 <sys_read+0x78>
80104ef0:	e8 3b eb ff ff       	call   80103a30 <myproc>
80104ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ef8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104efc:	85 f6                	test   %esi,%esi
80104efe:	74 48                	je     80104f48 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f00:	83 ec 08             	sub    $0x8,%esp
80104f03:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f06:	50                   	push   %eax
80104f07:	6a 02                	push   $0x2
80104f09:	e8 f2 fb ff ff       	call   80104b00 <argint>
80104f0e:	83 c4 10             	add    $0x10,%esp
80104f11:	85 c0                	test   %eax,%eax
80104f13:	78 33                	js     80104f48 <sys_read+0x78>
80104f15:	83 ec 04             	sub    $0x4,%esp
80104f18:	ff 75 f0             	push   -0x10(%ebp)
80104f1b:	53                   	push   %ebx
80104f1c:	6a 01                	push   $0x1
80104f1e:	e8 2d fc ff ff       	call   80104b50 <argptr>
80104f23:	83 c4 10             	add    $0x10,%esp
80104f26:	85 c0                	test   %eax,%eax
80104f28:	78 1e                	js     80104f48 <sys_read+0x78>
  return fileread(f, p, n);
80104f2a:	83 ec 04             	sub    $0x4,%esp
80104f2d:	ff 75 f0             	push   -0x10(%ebp)
80104f30:	ff 75 f4             	push   -0xc(%ebp)
80104f33:	56                   	push   %esi
80104f34:	e8 e7 c0 ff ff       	call   80101020 <fileread>
80104f39:	83 c4 10             	add    $0x10,%esp
}
80104f3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f3f:	5b                   	pop    %ebx
80104f40:	5e                   	pop    %esi
80104f41:	5d                   	pop    %ebp
80104f42:	c3                   	ret    
80104f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f47:	90                   	nop
    return -1;
80104f48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f4d:	eb ed                	jmp    80104f3c <sys_read+0x6c>
80104f4f:	90                   	nop

80104f50 <sys_write>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	56                   	push   %esi
80104f54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f55:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f5b:	53                   	push   %ebx
80104f5c:	6a 00                	push   $0x0
80104f5e:	e8 9d fb ff ff       	call   80104b00 <argint>
80104f63:	83 c4 10             	add    $0x10,%esp
80104f66:	85 c0                	test   %eax,%eax
80104f68:	78 5e                	js     80104fc8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f6e:	77 58                	ja     80104fc8 <sys_write+0x78>
80104f70:	e8 bb ea ff ff       	call   80103a30 <myproc>
80104f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f78:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f7c:	85 f6                	test   %esi,%esi
80104f7e:	74 48                	je     80104fc8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f80:	83 ec 08             	sub    $0x8,%esp
80104f83:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f86:	50                   	push   %eax
80104f87:	6a 02                	push   $0x2
80104f89:	e8 72 fb ff ff       	call   80104b00 <argint>
80104f8e:	83 c4 10             	add    $0x10,%esp
80104f91:	85 c0                	test   %eax,%eax
80104f93:	78 33                	js     80104fc8 <sys_write+0x78>
80104f95:	83 ec 04             	sub    $0x4,%esp
80104f98:	ff 75 f0             	push   -0x10(%ebp)
80104f9b:	53                   	push   %ebx
80104f9c:	6a 01                	push   $0x1
80104f9e:	e8 ad fb ff ff       	call   80104b50 <argptr>
80104fa3:	83 c4 10             	add    $0x10,%esp
80104fa6:	85 c0                	test   %eax,%eax
80104fa8:	78 1e                	js     80104fc8 <sys_write+0x78>
  return filewrite(f, p, n);
80104faa:	83 ec 04             	sub    $0x4,%esp
80104fad:	ff 75 f0             	push   -0x10(%ebp)
80104fb0:	ff 75 f4             	push   -0xc(%ebp)
80104fb3:	56                   	push   %esi
80104fb4:	e8 f7 c0 ff ff       	call   801010b0 <filewrite>
80104fb9:	83 c4 10             	add    $0x10,%esp
}
80104fbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fbf:	5b                   	pop    %ebx
80104fc0:	5e                   	pop    %esi
80104fc1:	5d                   	pop    %ebp
80104fc2:	c3                   	ret    
80104fc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fc7:	90                   	nop
    return -1;
80104fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fcd:	eb ed                	jmp    80104fbc <sys_write+0x6c>
80104fcf:	90                   	nop

80104fd0 <sys_close>:
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104fd8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fdb:	50                   	push   %eax
80104fdc:	6a 00                	push   $0x0
80104fde:	e8 1d fb ff ff       	call   80104b00 <argint>
80104fe3:	83 c4 10             	add    $0x10,%esp
80104fe6:	85 c0                	test   %eax,%eax
80104fe8:	78 3e                	js     80105028 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fee:	77 38                	ja     80105028 <sys_close+0x58>
80104ff0:	e8 3b ea ff ff       	call   80103a30 <myproc>
80104ff5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ff8:	8d 5a 08             	lea    0x8(%edx),%ebx
80104ffb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104fff:	85 f6                	test   %esi,%esi
80105001:	74 25                	je     80105028 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105003:	e8 28 ea ff ff       	call   80103a30 <myproc>
  fileclose(f);
80105008:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010500b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105012:	00 
  fileclose(f);
80105013:	56                   	push   %esi
80105014:	e8 d7 be ff ff       	call   80100ef0 <fileclose>
  return 0;
80105019:	83 c4 10             	add    $0x10,%esp
8010501c:	31 c0                	xor    %eax,%eax
}
8010501e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105021:	5b                   	pop    %ebx
80105022:	5e                   	pop    %esi
80105023:	5d                   	pop    %ebp
80105024:	c3                   	ret    
80105025:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105028:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010502d:	eb ef                	jmp    8010501e <sys_close+0x4e>
8010502f:	90                   	nop

80105030 <sys_fstat>:
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	56                   	push   %esi
80105034:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105035:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105038:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010503b:	53                   	push   %ebx
8010503c:	6a 00                	push   $0x0
8010503e:	e8 bd fa ff ff       	call   80104b00 <argint>
80105043:	83 c4 10             	add    $0x10,%esp
80105046:	85 c0                	test   %eax,%eax
80105048:	78 46                	js     80105090 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010504a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010504e:	77 40                	ja     80105090 <sys_fstat+0x60>
80105050:	e8 db e9 ff ff       	call   80103a30 <myproc>
80105055:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105058:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010505c:	85 f6                	test   %esi,%esi
8010505e:	74 30                	je     80105090 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105060:	83 ec 04             	sub    $0x4,%esp
80105063:	6a 14                	push   $0x14
80105065:	53                   	push   %ebx
80105066:	6a 01                	push   $0x1
80105068:	e8 e3 fa ff ff       	call   80104b50 <argptr>
8010506d:	83 c4 10             	add    $0x10,%esp
80105070:	85 c0                	test   %eax,%eax
80105072:	78 1c                	js     80105090 <sys_fstat+0x60>
  return filestat(f, st);
80105074:	83 ec 08             	sub    $0x8,%esp
80105077:	ff 75 f4             	push   -0xc(%ebp)
8010507a:	56                   	push   %esi
8010507b:	e8 50 bf ff ff       	call   80100fd0 <filestat>
80105080:	83 c4 10             	add    $0x10,%esp
}
80105083:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105086:	5b                   	pop    %ebx
80105087:	5e                   	pop    %esi
80105088:	5d                   	pop    %ebp
80105089:	c3                   	ret    
8010508a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105095:	eb ec                	jmp    80105083 <sys_fstat+0x53>
80105097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010509e:	66 90                	xchg   %ax,%ax

801050a0 <sys_link>:
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	57                   	push   %edi
801050a4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050a5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801050a8:	53                   	push   %ebx
801050a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050ac:	50                   	push   %eax
801050ad:	6a 00                	push   $0x0
801050af:	e8 0c fb ff ff       	call   80104bc0 <argstr>
801050b4:	83 c4 10             	add    $0x10,%esp
801050b7:	85 c0                	test   %eax,%eax
801050b9:	0f 88 fb 00 00 00    	js     801051ba <sys_link+0x11a>
801050bf:	83 ec 08             	sub    $0x8,%esp
801050c2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801050c5:	50                   	push   %eax
801050c6:	6a 01                	push   $0x1
801050c8:	e8 f3 fa ff ff       	call   80104bc0 <argstr>
801050cd:	83 c4 10             	add    $0x10,%esp
801050d0:	85 c0                	test   %eax,%eax
801050d2:	0f 88 e2 00 00 00    	js     801051ba <sys_link+0x11a>
  begin_op();
801050d8:	e8 43 dd ff ff       	call   80102e20 <begin_op>
  if((ip = namei(old)) == 0){
801050dd:	83 ec 0c             	sub    $0xc,%esp
801050e0:	ff 75 d4             	push   -0x2c(%ebp)
801050e3:	e8 b8 cf ff ff       	call   801020a0 <namei>
801050e8:	83 c4 10             	add    $0x10,%esp
801050eb:	89 c3                	mov    %eax,%ebx
801050ed:	85 c0                	test   %eax,%eax
801050ef:	0f 84 e4 00 00 00    	je     801051d9 <sys_link+0x139>
  ilock(ip);
801050f5:	83 ec 0c             	sub    $0xc,%esp
801050f8:	50                   	push   %eax
801050f9:	e8 82 c6 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
801050fe:	83 c4 10             	add    $0x10,%esp
80105101:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105106:	0f 84 b5 00 00 00    	je     801051c1 <sys_link+0x121>
  iupdate(ip);
8010510c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010510f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105114:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105117:	53                   	push   %ebx
80105118:	e8 b3 c5 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010511d:	89 1c 24             	mov    %ebx,(%esp)
80105120:	e8 3b c7 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105125:	58                   	pop    %eax
80105126:	5a                   	pop    %edx
80105127:	57                   	push   %edi
80105128:	ff 75 d0             	push   -0x30(%ebp)
8010512b:	e8 90 cf ff ff       	call   801020c0 <nameiparent>
80105130:	83 c4 10             	add    $0x10,%esp
80105133:	89 c6                	mov    %eax,%esi
80105135:	85 c0                	test   %eax,%eax
80105137:	74 5b                	je     80105194 <sys_link+0xf4>
  ilock(dp);
80105139:	83 ec 0c             	sub    $0xc,%esp
8010513c:	50                   	push   %eax
8010513d:	e8 3e c6 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105142:	8b 03                	mov    (%ebx),%eax
80105144:	83 c4 10             	add    $0x10,%esp
80105147:	39 06                	cmp    %eax,(%esi)
80105149:	75 3d                	jne    80105188 <sys_link+0xe8>
8010514b:	83 ec 04             	sub    $0x4,%esp
8010514e:	ff 73 04             	push   0x4(%ebx)
80105151:	57                   	push   %edi
80105152:	56                   	push   %esi
80105153:	e8 88 ce ff ff       	call   80101fe0 <dirlink>
80105158:	83 c4 10             	add    $0x10,%esp
8010515b:	85 c0                	test   %eax,%eax
8010515d:	78 29                	js     80105188 <sys_link+0xe8>
  iunlockput(dp);
8010515f:	83 ec 0c             	sub    $0xc,%esp
80105162:	56                   	push   %esi
80105163:	e8 a8 c8 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105168:	89 1c 24             	mov    %ebx,(%esp)
8010516b:	e8 40 c7 ff ff       	call   801018b0 <iput>
  end_op();
80105170:	e8 1b dd ff ff       	call   80102e90 <end_op>
  return 0;
80105175:	83 c4 10             	add    $0x10,%esp
80105178:	31 c0                	xor    %eax,%eax
}
8010517a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010517d:	5b                   	pop    %ebx
8010517e:	5e                   	pop    %esi
8010517f:	5f                   	pop    %edi
80105180:	5d                   	pop    %ebp
80105181:	c3                   	ret    
80105182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105188:	83 ec 0c             	sub    $0xc,%esp
8010518b:	56                   	push   %esi
8010518c:	e8 7f c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105191:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105194:	83 ec 0c             	sub    $0xc,%esp
80105197:	53                   	push   %ebx
80105198:	e8 e3 c5 ff ff       	call   80101780 <ilock>
  ip->nlink--;
8010519d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051a2:	89 1c 24             	mov    %ebx,(%esp)
801051a5:	e8 26 c5 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801051aa:	89 1c 24             	mov    %ebx,(%esp)
801051ad:	e8 5e c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
801051b2:	e8 d9 dc ff ff       	call   80102e90 <end_op>
  return -1;
801051b7:	83 c4 10             	add    $0x10,%esp
801051ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051bf:	eb b9                	jmp    8010517a <sys_link+0xda>
    iunlockput(ip);
801051c1:	83 ec 0c             	sub    $0xc,%esp
801051c4:	53                   	push   %ebx
801051c5:	e8 46 c8 ff ff       	call   80101a10 <iunlockput>
    end_op();
801051ca:	e8 c1 dc ff ff       	call   80102e90 <end_op>
    return -1;
801051cf:	83 c4 10             	add    $0x10,%esp
801051d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051d7:	eb a1                	jmp    8010517a <sys_link+0xda>
    end_op();
801051d9:	e8 b2 dc ff ff       	call   80102e90 <end_op>
    return -1;
801051de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051e3:	eb 95                	jmp    8010517a <sys_link+0xda>
801051e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051f0 <sys_unlink>:
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	57                   	push   %edi
801051f4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801051f5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801051f8:	53                   	push   %ebx
801051f9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801051fc:	50                   	push   %eax
801051fd:	6a 00                	push   $0x0
801051ff:	e8 bc f9 ff ff       	call   80104bc0 <argstr>
80105204:	83 c4 10             	add    $0x10,%esp
80105207:	85 c0                	test   %eax,%eax
80105209:	0f 88 7a 01 00 00    	js     80105389 <sys_unlink+0x199>
  begin_op();
8010520f:	e8 0c dc ff ff       	call   80102e20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105214:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105217:	83 ec 08             	sub    $0x8,%esp
8010521a:	53                   	push   %ebx
8010521b:	ff 75 c0             	push   -0x40(%ebp)
8010521e:	e8 9d ce ff ff       	call   801020c0 <nameiparent>
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105229:	85 c0                	test   %eax,%eax
8010522b:	0f 84 62 01 00 00    	je     80105393 <sys_unlink+0x1a3>
  ilock(dp);
80105231:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105234:	83 ec 0c             	sub    $0xc,%esp
80105237:	57                   	push   %edi
80105238:	e8 43 c5 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010523d:	58                   	pop    %eax
8010523e:	5a                   	pop    %edx
8010523f:	68 04 7f 10 80       	push   $0x80107f04
80105244:	53                   	push   %ebx
80105245:	e8 76 ca ff ff       	call   80101cc0 <namecmp>
8010524a:	83 c4 10             	add    $0x10,%esp
8010524d:	85 c0                	test   %eax,%eax
8010524f:	0f 84 fb 00 00 00    	je     80105350 <sys_unlink+0x160>
80105255:	83 ec 08             	sub    $0x8,%esp
80105258:	68 03 7f 10 80       	push   $0x80107f03
8010525d:	53                   	push   %ebx
8010525e:	e8 5d ca ff ff       	call   80101cc0 <namecmp>
80105263:	83 c4 10             	add    $0x10,%esp
80105266:	85 c0                	test   %eax,%eax
80105268:	0f 84 e2 00 00 00    	je     80105350 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010526e:	83 ec 04             	sub    $0x4,%esp
80105271:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105274:	50                   	push   %eax
80105275:	53                   	push   %ebx
80105276:	57                   	push   %edi
80105277:	e8 64 ca ff ff       	call   80101ce0 <dirlookup>
8010527c:	83 c4 10             	add    $0x10,%esp
8010527f:	89 c3                	mov    %eax,%ebx
80105281:	85 c0                	test   %eax,%eax
80105283:	0f 84 c7 00 00 00    	je     80105350 <sys_unlink+0x160>
  ilock(ip);
80105289:	83 ec 0c             	sub    $0xc,%esp
8010528c:	50                   	push   %eax
8010528d:	e8 ee c4 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80105292:	83 c4 10             	add    $0x10,%esp
80105295:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010529a:	0f 8e 1c 01 00 00    	jle    801053bc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801052a0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052a5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801052a8:	74 66                	je     80105310 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801052aa:	83 ec 04             	sub    $0x4,%esp
801052ad:	6a 10                	push   $0x10
801052af:	6a 00                	push   $0x0
801052b1:	57                   	push   %edi
801052b2:	e8 89 f5 ff ff       	call   80104840 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052b7:	6a 10                	push   $0x10
801052b9:	ff 75 c4             	push   -0x3c(%ebp)
801052bc:	57                   	push   %edi
801052bd:	ff 75 b4             	push   -0x4c(%ebp)
801052c0:	e8 cb c8 ff ff       	call   80101b90 <writei>
801052c5:	83 c4 20             	add    $0x20,%esp
801052c8:	83 f8 10             	cmp    $0x10,%eax
801052cb:	0f 85 de 00 00 00    	jne    801053af <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801052d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052d6:	0f 84 94 00 00 00    	je     80105370 <sys_unlink+0x180>
  iunlockput(dp);
801052dc:	83 ec 0c             	sub    $0xc,%esp
801052df:	ff 75 b4             	push   -0x4c(%ebp)
801052e2:	e8 29 c7 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
801052e7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052ec:	89 1c 24             	mov    %ebx,(%esp)
801052ef:	e8 dc c3 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801052f4:	89 1c 24             	mov    %ebx,(%esp)
801052f7:	e8 14 c7 ff ff       	call   80101a10 <iunlockput>
  end_op();
801052fc:	e8 8f db ff ff       	call   80102e90 <end_op>
  return 0;
80105301:	83 c4 10             	add    $0x10,%esp
80105304:	31 c0                	xor    %eax,%eax
}
80105306:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105309:	5b                   	pop    %ebx
8010530a:	5e                   	pop    %esi
8010530b:	5f                   	pop    %edi
8010530c:	5d                   	pop    %ebp
8010530d:	c3                   	ret    
8010530e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105310:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105314:	76 94                	jbe    801052aa <sys_unlink+0xba>
80105316:	be 20 00 00 00       	mov    $0x20,%esi
8010531b:	eb 0b                	jmp    80105328 <sys_unlink+0x138>
8010531d:	8d 76 00             	lea    0x0(%esi),%esi
80105320:	83 c6 10             	add    $0x10,%esi
80105323:	3b 73 58             	cmp    0x58(%ebx),%esi
80105326:	73 82                	jae    801052aa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105328:	6a 10                	push   $0x10
8010532a:	56                   	push   %esi
8010532b:	57                   	push   %edi
8010532c:	53                   	push   %ebx
8010532d:	e8 5e c7 ff ff       	call   80101a90 <readi>
80105332:	83 c4 10             	add    $0x10,%esp
80105335:	83 f8 10             	cmp    $0x10,%eax
80105338:	75 68                	jne    801053a2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010533a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010533f:	74 df                	je     80105320 <sys_unlink+0x130>
    iunlockput(ip);
80105341:	83 ec 0c             	sub    $0xc,%esp
80105344:	53                   	push   %ebx
80105345:	e8 c6 c6 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010534a:	83 c4 10             	add    $0x10,%esp
8010534d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105350:	83 ec 0c             	sub    $0xc,%esp
80105353:	ff 75 b4             	push   -0x4c(%ebp)
80105356:	e8 b5 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010535b:	e8 30 db ff ff       	call   80102e90 <end_op>
  return -1;
80105360:	83 c4 10             	add    $0x10,%esp
80105363:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105368:	eb 9c                	jmp    80105306 <sys_unlink+0x116>
8010536a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105370:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105373:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105376:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010537b:	50                   	push   %eax
8010537c:	e8 4f c3 ff ff       	call   801016d0 <iupdate>
80105381:	83 c4 10             	add    $0x10,%esp
80105384:	e9 53 ff ff ff       	jmp    801052dc <sys_unlink+0xec>
    return -1;
80105389:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010538e:	e9 73 ff ff ff       	jmp    80105306 <sys_unlink+0x116>
    end_op();
80105393:	e8 f8 da ff ff       	call   80102e90 <end_op>
    return -1;
80105398:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010539d:	e9 64 ff ff ff       	jmp    80105306 <sys_unlink+0x116>
      panic("isdirempty: readi");
801053a2:	83 ec 0c             	sub    $0xc,%esp
801053a5:	68 28 7f 10 80       	push   $0x80107f28
801053aa:	e8 d1 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801053af:	83 ec 0c             	sub    $0xc,%esp
801053b2:	68 3a 7f 10 80       	push   $0x80107f3a
801053b7:	e8 c4 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801053bc:	83 ec 0c             	sub    $0xc,%esp
801053bf:	68 16 7f 10 80       	push   $0x80107f16
801053c4:	e8 b7 af ff ff       	call   80100380 <panic>
801053c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053d0 <sys_open>:

int
sys_open(void)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	57                   	push   %edi
801053d4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801053d8:	53                   	push   %ebx
801053d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053dc:	50                   	push   %eax
801053dd:	6a 00                	push   $0x0
801053df:	e8 dc f7 ff ff       	call   80104bc0 <argstr>
801053e4:	83 c4 10             	add    $0x10,%esp
801053e7:	85 c0                	test   %eax,%eax
801053e9:	0f 88 8e 00 00 00    	js     8010547d <sys_open+0xad>
801053ef:	83 ec 08             	sub    $0x8,%esp
801053f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053f5:	50                   	push   %eax
801053f6:	6a 01                	push   $0x1
801053f8:	e8 03 f7 ff ff       	call   80104b00 <argint>
801053fd:	83 c4 10             	add    $0x10,%esp
80105400:	85 c0                	test   %eax,%eax
80105402:	78 79                	js     8010547d <sys_open+0xad>
    return -1;

  begin_op();
80105404:	e8 17 da ff ff       	call   80102e20 <begin_op>

  if(omode & O_CREATE){
80105409:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010540d:	75 79                	jne    80105488 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010540f:	83 ec 0c             	sub    $0xc,%esp
80105412:	ff 75 e0             	push   -0x20(%ebp)
80105415:	e8 86 cc ff ff       	call   801020a0 <namei>
8010541a:	83 c4 10             	add    $0x10,%esp
8010541d:	89 c6                	mov    %eax,%esi
8010541f:	85 c0                	test   %eax,%eax
80105421:	0f 84 7e 00 00 00    	je     801054a5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105427:	83 ec 0c             	sub    $0xc,%esp
8010542a:	50                   	push   %eax
8010542b:	e8 50 c3 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105430:	83 c4 10             	add    $0x10,%esp
80105433:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105438:	0f 84 c2 00 00 00    	je     80105500 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010543e:	e8 ed b9 ff ff       	call   80100e30 <filealloc>
80105443:	89 c7                	mov    %eax,%edi
80105445:	85 c0                	test   %eax,%eax
80105447:	74 23                	je     8010546c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105449:	e8 e2 e5 ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010544e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105450:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105454:	85 d2                	test   %edx,%edx
80105456:	74 60                	je     801054b8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105458:	83 c3 01             	add    $0x1,%ebx
8010545b:	83 fb 10             	cmp    $0x10,%ebx
8010545e:	75 f0                	jne    80105450 <sys_open+0x80>
    if(f)
      fileclose(f);
80105460:	83 ec 0c             	sub    $0xc,%esp
80105463:	57                   	push   %edi
80105464:	e8 87 ba ff ff       	call   80100ef0 <fileclose>
80105469:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010546c:	83 ec 0c             	sub    $0xc,%esp
8010546f:	56                   	push   %esi
80105470:	e8 9b c5 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105475:	e8 16 da ff ff       	call   80102e90 <end_op>
    return -1;
8010547a:	83 c4 10             	add    $0x10,%esp
8010547d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105482:	eb 6d                	jmp    801054f1 <sys_open+0x121>
80105484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105488:	83 ec 0c             	sub    $0xc,%esp
8010548b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010548e:	31 c9                	xor    %ecx,%ecx
80105490:	ba 02 00 00 00       	mov    $0x2,%edx
80105495:	6a 00                	push   $0x0
80105497:	e8 14 f8 ff ff       	call   80104cb0 <create>
    if(ip == 0){
8010549c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010549f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801054a1:	85 c0                	test   %eax,%eax
801054a3:	75 99                	jne    8010543e <sys_open+0x6e>
      end_op();
801054a5:	e8 e6 d9 ff ff       	call   80102e90 <end_op>
      return -1;
801054aa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054af:	eb 40                	jmp    801054f1 <sys_open+0x121>
801054b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801054b8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801054bb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801054bf:	56                   	push   %esi
801054c0:	e8 9b c3 ff ff       	call   80101860 <iunlock>
  end_op();
801054c5:	e8 c6 d9 ff ff       	call   80102e90 <end_op>

  f->type = FD_INODE;
801054ca:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801054d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054d3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801054d6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801054d9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801054db:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801054e2:	f7 d0                	not    %eax
801054e4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054e7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801054ea:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054ed:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801054f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054f4:	89 d8                	mov    %ebx,%eax
801054f6:	5b                   	pop    %ebx
801054f7:	5e                   	pop    %esi
801054f8:	5f                   	pop    %edi
801054f9:	5d                   	pop    %ebp
801054fa:	c3                   	ret    
801054fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054ff:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105500:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105503:	85 c9                	test   %ecx,%ecx
80105505:	0f 84 33 ff ff ff    	je     8010543e <sys_open+0x6e>
8010550b:	e9 5c ff ff ff       	jmp    8010546c <sys_open+0x9c>

80105510 <sys_mkdir>:

int
sys_mkdir(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105516:	e8 05 d9 ff ff       	call   80102e20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010551b:	83 ec 08             	sub    $0x8,%esp
8010551e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105521:	50                   	push   %eax
80105522:	6a 00                	push   $0x0
80105524:	e8 97 f6 ff ff       	call   80104bc0 <argstr>
80105529:	83 c4 10             	add    $0x10,%esp
8010552c:	85 c0                	test   %eax,%eax
8010552e:	78 30                	js     80105560 <sys_mkdir+0x50>
80105530:	83 ec 0c             	sub    $0xc,%esp
80105533:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105536:	31 c9                	xor    %ecx,%ecx
80105538:	ba 01 00 00 00       	mov    $0x1,%edx
8010553d:	6a 00                	push   $0x0
8010553f:	e8 6c f7 ff ff       	call   80104cb0 <create>
80105544:	83 c4 10             	add    $0x10,%esp
80105547:	85 c0                	test   %eax,%eax
80105549:	74 15                	je     80105560 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010554b:	83 ec 0c             	sub    $0xc,%esp
8010554e:	50                   	push   %eax
8010554f:	e8 bc c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105554:	e8 37 d9 ff ff       	call   80102e90 <end_op>
  return 0;
80105559:	83 c4 10             	add    $0x10,%esp
8010555c:	31 c0                	xor    %eax,%eax
}
8010555e:	c9                   	leave  
8010555f:	c3                   	ret    
    end_op();
80105560:	e8 2b d9 ff ff       	call   80102e90 <end_op>
    return -1;
80105565:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010556a:	c9                   	leave  
8010556b:	c3                   	ret    
8010556c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105570 <sys_mknod>:

int
sys_mknod(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105576:	e8 a5 d8 ff ff       	call   80102e20 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010557b:	83 ec 08             	sub    $0x8,%esp
8010557e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105581:	50                   	push   %eax
80105582:	6a 00                	push   $0x0
80105584:	e8 37 f6 ff ff       	call   80104bc0 <argstr>
80105589:	83 c4 10             	add    $0x10,%esp
8010558c:	85 c0                	test   %eax,%eax
8010558e:	78 60                	js     801055f0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105590:	83 ec 08             	sub    $0x8,%esp
80105593:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105596:	50                   	push   %eax
80105597:	6a 01                	push   $0x1
80105599:	e8 62 f5 ff ff       	call   80104b00 <argint>
  if((argstr(0, &path)) < 0 ||
8010559e:	83 c4 10             	add    $0x10,%esp
801055a1:	85 c0                	test   %eax,%eax
801055a3:	78 4b                	js     801055f0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801055a5:	83 ec 08             	sub    $0x8,%esp
801055a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055ab:	50                   	push   %eax
801055ac:	6a 02                	push   $0x2
801055ae:	e8 4d f5 ff ff       	call   80104b00 <argint>
     argint(1, &major) < 0 ||
801055b3:	83 c4 10             	add    $0x10,%esp
801055b6:	85 c0                	test   %eax,%eax
801055b8:	78 36                	js     801055f0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801055ba:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801055be:	83 ec 0c             	sub    $0xc,%esp
801055c1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801055c5:	ba 03 00 00 00       	mov    $0x3,%edx
801055ca:	50                   	push   %eax
801055cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801055ce:	e8 dd f6 ff ff       	call   80104cb0 <create>
     argint(2, &minor) < 0 ||
801055d3:	83 c4 10             	add    $0x10,%esp
801055d6:	85 c0                	test   %eax,%eax
801055d8:	74 16                	je     801055f0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055da:	83 ec 0c             	sub    $0xc,%esp
801055dd:	50                   	push   %eax
801055de:	e8 2d c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
801055e3:	e8 a8 d8 ff ff       	call   80102e90 <end_op>
  return 0;
801055e8:	83 c4 10             	add    $0x10,%esp
801055eb:	31 c0                	xor    %eax,%eax
}
801055ed:	c9                   	leave  
801055ee:	c3                   	ret    
801055ef:	90                   	nop
    end_op();
801055f0:	e8 9b d8 ff ff       	call   80102e90 <end_op>
    return -1;
801055f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055fa:	c9                   	leave  
801055fb:	c3                   	ret    
801055fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105600 <sys_chdir>:

int
sys_chdir(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	56                   	push   %esi
80105604:	53                   	push   %ebx
80105605:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105608:	e8 23 e4 ff ff       	call   80103a30 <myproc>
8010560d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010560f:	e8 0c d8 ff ff       	call   80102e20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105614:	83 ec 08             	sub    $0x8,%esp
80105617:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010561a:	50                   	push   %eax
8010561b:	6a 00                	push   $0x0
8010561d:	e8 9e f5 ff ff       	call   80104bc0 <argstr>
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	85 c0                	test   %eax,%eax
80105627:	78 77                	js     801056a0 <sys_chdir+0xa0>
80105629:	83 ec 0c             	sub    $0xc,%esp
8010562c:	ff 75 f4             	push   -0xc(%ebp)
8010562f:	e8 6c ca ff ff       	call   801020a0 <namei>
80105634:	83 c4 10             	add    $0x10,%esp
80105637:	89 c3                	mov    %eax,%ebx
80105639:	85 c0                	test   %eax,%eax
8010563b:	74 63                	je     801056a0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010563d:	83 ec 0c             	sub    $0xc,%esp
80105640:	50                   	push   %eax
80105641:	e8 3a c1 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105646:	83 c4 10             	add    $0x10,%esp
80105649:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010564e:	75 30                	jne    80105680 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	53                   	push   %ebx
80105654:	e8 07 c2 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105659:	58                   	pop    %eax
8010565a:	ff 76 68             	push   0x68(%esi)
8010565d:	e8 4e c2 ff ff       	call   801018b0 <iput>
  end_op();
80105662:	e8 29 d8 ff ff       	call   80102e90 <end_op>
  curproc->cwd = ip;
80105667:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010566a:	83 c4 10             	add    $0x10,%esp
8010566d:	31 c0                	xor    %eax,%eax
}
8010566f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105672:	5b                   	pop    %ebx
80105673:	5e                   	pop    %esi
80105674:	5d                   	pop    %ebp
80105675:	c3                   	ret    
80105676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010567d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	53                   	push   %ebx
80105684:	e8 87 c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105689:	e8 02 d8 ff ff       	call   80102e90 <end_op>
    return -1;
8010568e:	83 c4 10             	add    $0x10,%esp
80105691:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105696:	eb d7                	jmp    8010566f <sys_chdir+0x6f>
80105698:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569f:	90                   	nop
    end_op();
801056a0:	e8 eb d7 ff ff       	call   80102e90 <end_op>
    return -1;
801056a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056aa:	eb c3                	jmp    8010566f <sys_chdir+0x6f>
801056ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056b0 <sys_exec>:

int
sys_exec(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	57                   	push   %edi
801056b4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056b5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801056bb:	53                   	push   %ebx
801056bc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056c2:	50                   	push   %eax
801056c3:	6a 00                	push   $0x0
801056c5:	e8 f6 f4 ff ff       	call   80104bc0 <argstr>
801056ca:	83 c4 10             	add    $0x10,%esp
801056cd:	85 c0                	test   %eax,%eax
801056cf:	0f 88 87 00 00 00    	js     8010575c <sys_exec+0xac>
801056d5:	83 ec 08             	sub    $0x8,%esp
801056d8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801056de:	50                   	push   %eax
801056df:	6a 01                	push   $0x1
801056e1:	e8 1a f4 ff ff       	call   80104b00 <argint>
801056e6:	83 c4 10             	add    $0x10,%esp
801056e9:	85 c0                	test   %eax,%eax
801056eb:	78 6f                	js     8010575c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801056ed:	83 ec 04             	sub    $0x4,%esp
801056f0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801056f6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801056f8:	68 80 00 00 00       	push   $0x80
801056fd:	6a 00                	push   $0x0
801056ff:	56                   	push   %esi
80105700:	e8 3b f1 ff ff       	call   80104840 <memset>
80105705:	83 c4 10             	add    $0x10,%esp
80105708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105710:	83 ec 08             	sub    $0x8,%esp
80105713:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105719:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105720:	50                   	push   %eax
80105721:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105727:	01 f8                	add    %edi,%eax
80105729:	50                   	push   %eax
8010572a:	e8 41 f3 ff ff       	call   80104a70 <fetchint>
8010572f:	83 c4 10             	add    $0x10,%esp
80105732:	85 c0                	test   %eax,%eax
80105734:	78 26                	js     8010575c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105736:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010573c:	85 c0                	test   %eax,%eax
8010573e:	74 30                	je     80105770 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105740:	83 ec 08             	sub    $0x8,%esp
80105743:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105746:	52                   	push   %edx
80105747:	50                   	push   %eax
80105748:	e8 63 f3 ff ff       	call   80104ab0 <fetchstr>
8010574d:	83 c4 10             	add    $0x10,%esp
80105750:	85 c0                	test   %eax,%eax
80105752:	78 08                	js     8010575c <sys_exec+0xac>
  for(i=0;; i++){
80105754:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105757:	83 fb 20             	cmp    $0x20,%ebx
8010575a:	75 b4                	jne    80105710 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010575c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010575f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105764:	5b                   	pop    %ebx
80105765:	5e                   	pop    %esi
80105766:	5f                   	pop    %edi
80105767:	5d                   	pop    %ebp
80105768:	c3                   	ret    
80105769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105770:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105777:	00 00 00 00 
  return exec(path, argv);
8010577b:	83 ec 08             	sub    $0x8,%esp
8010577e:	56                   	push   %esi
8010577f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105785:	e8 26 b3 ff ff       	call   80100ab0 <exec>
8010578a:	83 c4 10             	add    $0x10,%esp
}
8010578d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105790:	5b                   	pop    %ebx
80105791:	5e                   	pop    %esi
80105792:	5f                   	pop    %edi
80105793:	5d                   	pop    %ebp
80105794:	c3                   	ret    
80105795:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057a0 <sys_pipe>:

int
sys_pipe(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	57                   	push   %edi
801057a4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057a5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801057a8:	53                   	push   %ebx
801057a9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057ac:	6a 08                	push   $0x8
801057ae:	50                   	push   %eax
801057af:	6a 00                	push   $0x0
801057b1:	e8 9a f3 ff ff       	call   80104b50 <argptr>
801057b6:	83 c4 10             	add    $0x10,%esp
801057b9:	85 c0                	test   %eax,%eax
801057bb:	78 4a                	js     80105807 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801057bd:	83 ec 08             	sub    $0x8,%esp
801057c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057c3:	50                   	push   %eax
801057c4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057c7:	50                   	push   %eax
801057c8:	e8 23 dd ff ff       	call   801034f0 <pipealloc>
801057cd:	83 c4 10             	add    $0x10,%esp
801057d0:	85 c0                	test   %eax,%eax
801057d2:	78 33                	js     80105807 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057d4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801057d7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057d9:	e8 52 e2 ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057de:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801057e0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801057e4:	85 f6                	test   %esi,%esi
801057e6:	74 28                	je     80105810 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801057e8:	83 c3 01             	add    $0x1,%ebx
801057eb:	83 fb 10             	cmp    $0x10,%ebx
801057ee:	75 f0                	jne    801057e0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801057f0:	83 ec 0c             	sub    $0xc,%esp
801057f3:	ff 75 e0             	push   -0x20(%ebp)
801057f6:	e8 f5 b6 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
801057fb:	58                   	pop    %eax
801057fc:	ff 75 e4             	push   -0x1c(%ebp)
801057ff:	e8 ec b6 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105804:	83 c4 10             	add    $0x10,%esp
80105807:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580c:	eb 53                	jmp    80105861 <sys_pipe+0xc1>
8010580e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105810:	8d 73 08             	lea    0x8(%ebx),%esi
80105813:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105817:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010581a:	e8 11 e2 ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010581f:	31 d2                	xor    %edx,%edx
80105821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105828:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010582c:	85 c9                	test   %ecx,%ecx
8010582e:	74 20                	je     80105850 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105830:	83 c2 01             	add    $0x1,%edx
80105833:	83 fa 10             	cmp    $0x10,%edx
80105836:	75 f0                	jne    80105828 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105838:	e8 f3 e1 ff ff       	call   80103a30 <myproc>
8010583d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105844:	00 
80105845:	eb a9                	jmp    801057f0 <sys_pipe+0x50>
80105847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105850:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105854:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105857:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105859:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010585c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010585f:	31 c0                	xor    %eax,%eax
}
80105861:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105864:	5b                   	pop    %ebx
80105865:	5e                   	pop    %esi
80105866:	5f                   	pop    %edi
80105867:	5d                   	pop    %ebp
80105868:	c3                   	ret    
80105869:	66 90                	xchg   %ax,%ax
8010586b:	66 90                	xchg   %ax,%ax
8010586d:	66 90                	xchg   %ax,%ax
8010586f:	90                   	nop

80105870 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105870:	e9 5b e3 ff ff       	jmp    80103bd0 <fork>
80105875:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105880 <sys_forkcow>:
}

int
sys_forkcow(void)
{
  return forkcow();
80105880:	e9 6b e4 ff ff       	jmp    80103cf0 <forkcow>
80105885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010588c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105890 <sys_exit>:
}

int
sys_exit(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	83 ec 08             	sub    $0x8,%esp
  exit();
80105896:	e8 d5 e6 ff ff       	call   80103f70 <exit>
  return 0;  // not reached
}
8010589b:	31 c0                	xor    %eax,%eax
8010589d:	c9                   	leave  
8010589e:	c3                   	ret    
8010589f:	90                   	nop

801058a0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801058a0:	e9 fb e7 ff ff       	jmp    801040a0 <wait>
801058a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058b0 <sys_kill>:
}

int
sys_kill(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801058b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058b9:	50                   	push   %eax
801058ba:	6a 00                	push   $0x0
801058bc:	e8 3f f2 ff ff       	call   80104b00 <argint>
801058c1:	83 c4 10             	add    $0x10,%esp
801058c4:	85 c0                	test   %eax,%eax
801058c6:	78 18                	js     801058e0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801058c8:	83 ec 0c             	sub    $0xc,%esp
801058cb:	ff 75 f4             	push   -0xc(%ebp)
801058ce:	e8 6d ea ff ff       	call   80104340 <kill>
801058d3:	83 c4 10             	add    $0x10,%esp
}
801058d6:	c9                   	leave  
801058d7:	c3                   	ret    
801058d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058df:	90                   	nop
801058e0:	c9                   	leave  
    return -1;
801058e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058e6:	c3                   	ret    
801058e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ee:	66 90                	xchg   %ax,%ax

801058f0 <sys_getpid>:

int
sys_getpid(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801058f6:	e8 35 e1 ff ff       	call   80103a30 <myproc>
801058fb:	8b 40 10             	mov    0x10(%eax),%eax
}
801058fe:	c9                   	leave  
801058ff:	c3                   	ret    

80105900 <sys_sbrk>:

int
sys_sbrk(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105904:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105907:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010590a:	50                   	push   %eax
8010590b:	6a 00                	push   $0x0
8010590d:	e8 ee f1 ff ff       	call   80104b00 <argint>
80105912:	83 c4 10             	add    $0x10,%esp
80105915:	85 c0                	test   %eax,%eax
80105917:	78 27                	js     80105940 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105919:	e8 12 e1 ff ff       	call   80103a30 <myproc>
  if(growproc(n) < 0)
8010591e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105921:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105923:	ff 75 f4             	push   -0xc(%ebp)
80105926:	e8 25 e2 ff ff       	call   80103b50 <growproc>
8010592b:	83 c4 10             	add    $0x10,%esp
8010592e:	85 c0                	test   %eax,%eax
80105930:	78 0e                	js     80105940 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105932:	89 d8                	mov    %ebx,%eax
80105934:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105937:	c9                   	leave  
80105938:	c3                   	ret    
80105939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105940:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105945:	eb eb                	jmp    80105932 <sys_sbrk+0x32>
80105947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594e:	66 90                	xchg   %ax,%ax

80105950 <sys_sleep>:

int
sys_sleep(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105954:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105957:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010595a:	50                   	push   %eax
8010595b:	6a 00                	push   $0x0
8010595d:	e8 9e f1 ff ff       	call   80104b00 <argint>
80105962:	83 c4 10             	add    $0x10,%esp
80105965:	85 c0                	test   %eax,%eax
80105967:	0f 88 8a 00 00 00    	js     801059f7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010596d:	83 ec 0c             	sub    $0xc,%esp
80105970:	68 80 cc 14 80       	push   $0x8014cc80
80105975:	e8 06 ee ff ff       	call   80104780 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010597a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010597d:	8b 1d 60 cc 14 80    	mov    0x8014cc60,%ebx
  while(ticks - ticks0 < n){
80105983:	83 c4 10             	add    $0x10,%esp
80105986:	85 d2                	test   %edx,%edx
80105988:	75 27                	jne    801059b1 <sys_sleep+0x61>
8010598a:	eb 54                	jmp    801059e0 <sys_sleep+0x90>
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105990:	83 ec 08             	sub    $0x8,%esp
80105993:	68 80 cc 14 80       	push   $0x8014cc80
80105998:	68 60 cc 14 80       	push   $0x8014cc60
8010599d:	e8 7e e8 ff ff       	call   80104220 <sleep>
  while(ticks - ticks0 < n){
801059a2:	a1 60 cc 14 80       	mov    0x8014cc60,%eax
801059a7:	83 c4 10             	add    $0x10,%esp
801059aa:	29 d8                	sub    %ebx,%eax
801059ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801059af:	73 2f                	jae    801059e0 <sys_sleep+0x90>
    if(myproc()->killed){
801059b1:	e8 7a e0 ff ff       	call   80103a30 <myproc>
801059b6:	8b 40 24             	mov    0x24(%eax),%eax
801059b9:	85 c0                	test   %eax,%eax
801059bb:	74 d3                	je     80105990 <sys_sleep+0x40>
      release(&tickslock);
801059bd:	83 ec 0c             	sub    $0xc,%esp
801059c0:	68 80 cc 14 80       	push   $0x8014cc80
801059c5:	e8 56 ed ff ff       	call   80104720 <release>
  }
  release(&tickslock);
  return 0;
}
801059ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801059cd:	83 c4 10             	add    $0x10,%esp
801059d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059d5:	c9                   	leave  
801059d6:	c3                   	ret    
801059d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059de:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801059e0:	83 ec 0c             	sub    $0xc,%esp
801059e3:	68 80 cc 14 80       	push   $0x8014cc80
801059e8:	e8 33 ed ff ff       	call   80104720 <release>
  return 0;
801059ed:	83 c4 10             	add    $0x10,%esp
801059f0:	31 c0                	xor    %eax,%eax
}
801059f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059f5:	c9                   	leave  
801059f6:	c3                   	ret    
    return -1;
801059f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059fc:	eb f4                	jmp    801059f2 <sys_sleep+0xa2>
801059fe:	66 90                	xchg   %ax,%ax

80105a00 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	53                   	push   %ebx
80105a04:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a07:	68 80 cc 14 80       	push   $0x8014cc80
80105a0c:	e8 6f ed ff ff       	call   80104780 <acquire>
  xticks = ticks;
80105a11:	8b 1d 60 cc 14 80    	mov    0x8014cc60,%ebx
  release(&tickslock);
80105a17:	c7 04 24 80 cc 14 80 	movl   $0x8014cc80,(%esp)
80105a1e:	e8 fd ec ff ff       	call   80104720 <release>
  return xticks;
}
80105a23:	89 d8                	mov    %ebx,%eax
80105a25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a28:	c9                   	leave  
80105a29:	c3                   	ret    
80105a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a30 <sys_date>:

int
sys_date(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	83 ec 1c             	sub    $0x1c,%esp
  char *ptr;
  argptr(0, &ptr, sizeof(struct rtcdate*));
80105a36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a39:	6a 04                	push   $0x4
80105a3b:	50                   	push   %eax
80105a3c:	6a 00                	push   $0x0
80105a3e:	e8 0d f1 ff ff       	call   80104b50 <argptr>
  // seu código aqui

  struct rtcdate* r = (struct rtcdate*)ptr;

  cmostime(r);
80105a43:	58                   	pop    %eax
80105a44:	ff 75 f4             	push   -0xc(%ebp)
80105a47:	e8 44 d0 ff ff       	call   80102a90 <cmostime>

  return 0;
}
80105a4c:	31 c0                	xor    %eax,%eax
80105a4e:	c9                   	leave  
80105a4f:	c3                   	ret    

80105a50 <sys_virt2real>:



int
sys_virt2real(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 1c             	sub    $0x1c,%esp

  char *ptr;
  argptr(0, &ptr, sizeof(char*));
80105a56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a59:	6a 04                	push   $0x4
80105a5b:	50                   	push   %eax
80105a5c:	6a 00                	push   $0x0
80105a5e:	e8 ed f0 ff ff       	call   80104b50 <argptr>

  pde_t *pgdir = myproc()->pgdir;
80105a63:	e8 c8 df ff ff       	call   80103a30 <myproc>
  pte_t *pte = walkpgdir(pgdir, ptr, 0);
80105a68:	83 c4 0c             	add    $0xc,%esp
80105a6b:	6a 00                	push   $0x0
80105a6d:	ff 75 f4             	push   -0xc(%ebp)
80105a70:	ff 70 04             	push   0x4(%eax)
80105a73:	e8 a8 13 00 00       	call   80106e20 <walkpgdir>

  if (pte == 0 || !(*pte & PTE_P)) {
80105a78:	83 c4 10             	add    $0x10,%esp
80105a7b:	85 c0                	test   %eax,%eax
80105a7d:	74 21                	je     80105aa0 <sys_virt2real+0x50>
80105a7f:	8b 10                	mov    (%eax),%edx
    return 0;
80105a81:	31 c0                	xor    %eax,%eax
  if (pte == 0 || !(*pte & PTE_P)) {
80105a83:	f6 c2 01             	test   $0x1,%dl
80105a86:	74 10                	je     80105a98 <sys_virt2real+0x48>
  }

  return (int)PTE_ADDR(*pte) + ((uint)ptr & 0xFFF);
80105a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a8b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80105a91:	25 ff 0f 00 00       	and    $0xfff,%eax
80105a96:	09 d0                	or     %edx,%eax
}
80105a98:	c9                   	leave  
80105a99:	c3                   	ret    
80105a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105aa0:	c9                   	leave  
    return 0;
80105aa1:	31 c0                	xor    %eax,%eax
}
80105aa3:	c3                   	ret    
80105aa4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aaf:	90                   	nop

80105ab0 <sys_num_pages>:

int
sys_num_pages(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	57                   	push   %edi
80105ab4:	56                   	push   %esi
80105ab5:	53                   	push   %ebx
80105ab6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p = myproc(); 
80105ab9:	e8 72 df ff ff       	call   80103a30 <myproc>
    if (!p) {
80105abe:	85 c0                	test   %eax,%eax
80105ac0:	74 51                	je     80105b13 <sys_num_pages+0x63>
    }

    pde_t *pgdir = p->pgdir; 
    int count = 0;

    for (int i = 0; i < NPDENTRIES; i++) {
80105ac2:	8b 70 04             	mov    0x4(%eax),%esi
    int count = 0;
80105ac5:	31 c9                	xor    %ecx,%ecx
80105ac7:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80105acd:	eb 08                	jmp    80105ad7 <sys_num_pages+0x27>
80105acf:	90                   	nop
    for (int i = 0; i < NPDENTRIES; i++) {
80105ad0:	83 c6 04             	add    $0x4,%esi
80105ad3:	39 fe                	cmp    %edi,%esi
80105ad5:	74 32                	je     80105b09 <sys_num_pages+0x59>
        if (pgdir[i] & PTE_P) { 
80105ad7:	8b 1e                	mov    (%esi),%ebx
80105ad9:	f6 c3 01             	test   $0x1,%bl
80105adc:	74 f2                	je     80105ad0 <sys_num_pages+0x20>
            pte_t *pte = (pte_t *)P2V(PTE_ADDR(pgdir[i])); 
80105ade:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105ae4:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
            for (int j = 0; j < NPTENTRIES; j++) {
80105aea:	81 eb 00 f0 ff 7f    	sub    $0x7ffff000,%ebx
                if (pte[j] & PTE_P) { 
80105af0:	8b 10                	mov    (%eax),%edx
80105af2:	83 e2 01             	and    $0x1,%edx
                    count++; 
80105af5:	83 fa 01             	cmp    $0x1,%edx
80105af8:	83 d9 ff             	sbb    $0xffffffff,%ecx
            for (int j = 0; j < NPTENTRIES; j++) {
80105afb:	83 c0 04             	add    $0x4,%eax
80105afe:	39 c3                	cmp    %eax,%ebx
80105b00:	75 ee                	jne    80105af0 <sys_num_pages+0x40>
    for (int i = 0; i < NPDENTRIES; i++) {
80105b02:	83 c6 04             	add    $0x4,%esi
80105b05:	39 fe                	cmp    %edi,%esi
80105b07:	75 ce                	jne    80105ad7 <sys_num_pages+0x27>
            }
        }
    }

    return count;
80105b09:	83 c4 0c             	add    $0xc,%esp
80105b0c:	89 c8                	mov    %ecx,%eax
80105b0e:	5b                   	pop    %ebx
80105b0f:	5e                   	pop    %esi
80105b10:	5f                   	pop    %edi
80105b11:	5d                   	pop    %ebp
80105b12:	c3                   	ret    
80105b13:	83 c4 0c             	add    $0xc,%esp
        return 0; 
80105b16:	31 c9                	xor    %ecx,%ecx
80105b18:	5b                   	pop    %ebx
80105b19:	89 c8                	mov    %ecx,%eax
80105b1b:	5e                   	pop    %esi
80105b1c:	5f                   	pop    %edi
80105b1d:	5d                   	pop    %ebp
80105b1e:	c3                   	ret    

80105b1f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b1f:	1e                   	push   %ds
  pushl %es
80105b20:	06                   	push   %es
  pushl %fs
80105b21:	0f a0                	push   %fs
  pushl %gs
80105b23:	0f a8                	push   %gs
  pushal
80105b25:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b26:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b2a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b2c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b2e:	54                   	push   %esp
  call trap
80105b2f:	e8 cc 00 00 00       	call   80105c00 <trap>
  addl $4, %esp
80105b34:	83 c4 04             	add    $0x4,%esp

80105b37 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b37:	61                   	popa   
  popl %gs
80105b38:	0f a9                	pop    %gs
  popl %fs
80105b3a:	0f a1                	pop    %fs
  popl %es
80105b3c:	07                   	pop    %es
  popl %ds
80105b3d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b3e:	83 c4 08             	add    $0x8,%esp
  iret
80105b41:	cf                   	iret   
80105b42:	66 90                	xchg   %ax,%ax
80105b44:	66 90                	xchg   %ax,%ax
80105b46:	66 90                	xchg   %ax,%ax
80105b48:	66 90                	xchg   %ax,%ax
80105b4a:	66 90                	xchg   %ax,%ax
80105b4c:	66 90                	xchg   %ax,%ax
80105b4e:	66 90                	xchg   %ax,%ax

80105b50 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b50:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b51:	31 c0                	xor    %eax,%eax
{
80105b53:	89 e5                	mov    %esp,%ebp
80105b55:	83 ec 08             	sub    $0x8,%esp
80105b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b60:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105b67:	c7 04 c5 c2 cc 14 80 	movl   $0x8e000008,-0x7feb333e(,%eax,8)
80105b6e:	08 00 00 8e 
80105b72:	66 89 14 c5 c0 cc 14 	mov    %dx,-0x7feb3340(,%eax,8)
80105b79:	80 
80105b7a:	c1 ea 10             	shr    $0x10,%edx
80105b7d:	66 89 14 c5 c6 cc 14 	mov    %dx,-0x7feb333a(,%eax,8)
80105b84:	80 
  for(i = 0; i < 256; i++)
80105b85:	83 c0 01             	add    $0x1,%eax
80105b88:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b8d:	75 d1                	jne    80105b60 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105b8f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b92:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105b97:	c7 05 c2 ce 14 80 08 	movl   $0xef000008,0x8014cec2
80105b9e:	00 00 ef 
  initlock(&tickslock, "time");
80105ba1:	68 49 7f 10 80       	push   $0x80107f49
80105ba6:	68 80 cc 14 80       	push   $0x8014cc80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bab:	66 a3 c0 ce 14 80    	mov    %ax,0x8014cec0
80105bb1:	c1 e8 10             	shr    $0x10,%eax
80105bb4:	66 a3 c6 ce 14 80    	mov    %ax,0x8014cec6
  initlock(&tickslock, "time");
80105bba:	e8 f1 e9 ff ff       	call   801045b0 <initlock>
}
80105bbf:	83 c4 10             	add    $0x10,%esp
80105bc2:	c9                   	leave  
80105bc3:	c3                   	ret    
80105bc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bcf:	90                   	nop

80105bd0 <idtinit>:

void
idtinit(void)
{
80105bd0:	55                   	push   %ebp
  pd[0] = size-1;
80105bd1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105bd6:	89 e5                	mov    %esp,%ebp
80105bd8:	83 ec 10             	sub    $0x10,%esp
80105bdb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105bdf:	b8 c0 cc 14 80       	mov    $0x8014ccc0,%eax
80105be4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105be8:	c1 e8 10             	shr    $0x10,%eax
80105beb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105bef:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105bf2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105bf5:	c9                   	leave  
80105bf6:	c3                   	ret    
80105bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bfe:	66 90                	xchg   %ax,%ax

80105c00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	57                   	push   %edi
80105c04:	56                   	push   %esi
80105c05:	53                   	push   %ebx
80105c06:	83 ec 1c             	sub    $0x1c,%esp
80105c09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105c0c:	8b 43 30             	mov    0x30(%ebx),%eax
80105c0f:	83 f8 40             	cmp    $0x40,%eax
80105c12:	0f 84 38 01 00 00    	je     80105d50 <trap+0x150>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c18:	83 e8 0e             	sub    $0xe,%eax
80105c1b:	83 f8 31             	cmp    $0x31,%eax
80105c1e:	0f 87 8c 00 00 00    	ja     80105cb0 <trap+0xb0>
80105c24:	ff 24 85 34 80 10 80 	jmp    *-0x7fef7fcc(,%eax,4)
80105c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c2f:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105c30:	e8 db dd ff ff       	call   80103a10 <cpuid>
80105c35:	85 c0                	test   %eax,%eax
80105c37:	0f 84 53 02 00 00    	je     80105e90 <trap+0x290>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105c3d:	e8 8e cd ff ff       	call   801029d0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c42:	e8 e9 dd ff ff       	call   80103a30 <myproc>
80105c47:	85 c0                	test   %eax,%eax
80105c49:	74 1d                	je     80105c68 <trap+0x68>
80105c4b:	e8 e0 dd ff ff       	call   80103a30 <myproc>
80105c50:	8b 50 24             	mov    0x24(%eax),%edx
80105c53:	85 d2                	test   %edx,%edx
80105c55:	74 11                	je     80105c68 <trap+0x68>
80105c57:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c5b:	83 e0 03             	and    $0x3,%eax
80105c5e:	66 83 f8 03          	cmp    $0x3,%ax
80105c62:	0f 84 08 02 00 00    	je     80105e70 <trap+0x270>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105c68:	e8 c3 dd ff ff       	call   80103a30 <myproc>
80105c6d:	85 c0                	test   %eax,%eax
80105c6f:	74 0f                	je     80105c80 <trap+0x80>
80105c71:	e8 ba dd ff ff       	call   80103a30 <myproc>
80105c76:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105c7a:	0f 84 b8 00 00 00    	je     80105d38 <trap+0x138>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c80:	e8 ab dd ff ff       	call   80103a30 <myproc>
80105c85:	85 c0                	test   %eax,%eax
80105c87:	74 1d                	je     80105ca6 <trap+0xa6>
80105c89:	e8 a2 dd ff ff       	call   80103a30 <myproc>
80105c8e:	8b 40 24             	mov    0x24(%eax),%eax
80105c91:	85 c0                	test   %eax,%eax
80105c93:	74 11                	je     80105ca6 <trap+0xa6>
80105c95:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c99:	83 e0 03             	and    $0x3,%eax
80105c9c:	66 83 f8 03          	cmp    $0x3,%ax
80105ca0:	0f 84 d7 00 00 00    	je     80105d7d <trap+0x17d>
    exit();
}
80105ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ca9:	5b                   	pop    %ebx
80105caa:	5e                   	pop    %esi
80105cab:	5f                   	pop    %edi
80105cac:	5d                   	pop    %ebp
80105cad:	c3                   	ret    
80105cae:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105cb0:	e8 7b dd ff ff       	call   80103a30 <myproc>
80105cb5:	85 c0                	test   %eax,%eax
80105cb7:	0f 84 d3 02 00 00    	je     80105f90 <trap+0x390>
80105cbd:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105cc1:	0f 84 c9 02 00 00    	je     80105f90 <trap+0x390>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105cc7:	0f 20 d1             	mov    %cr2,%ecx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cca:	8b 53 38             	mov    0x38(%ebx),%edx
80105ccd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105cd0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105cd3:	e8 38 dd ff ff       	call   80103a10 <cpuid>
80105cd8:	8b 73 30             	mov    0x30(%ebx),%esi
80105cdb:	89 c7                	mov    %eax,%edi
80105cdd:	8b 43 34             	mov    0x34(%ebx),%eax
80105ce0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105ce3:	e8 48 dd ff ff       	call   80103a30 <myproc>
80105ce8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ceb:	e8 40 dd ff ff       	call   80103a30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cf0:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105cf3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105cf6:	51                   	push   %ecx
80105cf7:	52                   	push   %edx
80105cf8:	57                   	push   %edi
80105cf9:	ff 75 e4             	push   -0x1c(%ebp)
80105cfc:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105cfd:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105d00:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d03:	56                   	push   %esi
80105d04:	ff 70 10             	push   0x10(%eax)
80105d07:	68 f0 7f 10 80       	push   $0x80107ff0
80105d0c:	e8 8f a9 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105d11:	83 c4 20             	add    $0x20,%esp
80105d14:	e8 17 dd ff ff       	call   80103a30 <myproc>
80105d19:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d20:	e8 0b dd ff ff       	call   80103a30 <myproc>
80105d25:	85 c0                	test   %eax,%eax
80105d27:	0f 85 1e ff ff ff    	jne    80105c4b <trap+0x4b>
80105d2d:	e9 36 ff ff ff       	jmp    80105c68 <trap+0x68>
80105d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105d38:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105d3c:	0f 85 3e ff ff ff    	jne    80105c80 <trap+0x80>
    yield();
80105d42:	e8 89 e4 ff ff       	call   801041d0 <yield>
80105d47:	e9 34 ff ff ff       	jmp    80105c80 <trap+0x80>
80105d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105d50:	e8 db dc ff ff       	call   80103a30 <myproc>
80105d55:	8b 70 24             	mov    0x24(%eax),%esi
80105d58:	85 f6                	test   %esi,%esi
80105d5a:	0f 85 20 01 00 00    	jne    80105e80 <trap+0x280>
    myproc()->tf = tf;
80105d60:	e8 cb dc ff ff       	call   80103a30 <myproc>
80105d65:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105d68:	e8 d3 ee ff ff       	call   80104c40 <syscall>
    if(myproc()->killed)
80105d6d:	e8 be dc ff ff       	call   80103a30 <myproc>
80105d72:	8b 48 24             	mov    0x24(%eax),%ecx
80105d75:	85 c9                	test   %ecx,%ecx
80105d77:	0f 84 29 ff ff ff    	je     80105ca6 <trap+0xa6>
}
80105d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d80:	5b                   	pop    %ebx
80105d81:	5e                   	pop    %esi
80105d82:	5f                   	pop    %edi
80105d83:	5d                   	pop    %ebp
      exit();
80105d84:	e9 e7 e1 ff ff       	jmp    80103f70 <exit>
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105d90:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d93:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105d97:	e8 74 dc ff ff       	call   80103a10 <cpuid>
80105d9c:	57                   	push   %edi
80105d9d:	56                   	push   %esi
80105d9e:	50                   	push   %eax
80105d9f:	68 74 7f 10 80       	push   $0x80107f74
80105da4:	e8 f7 a8 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105da9:	e8 22 cc ff ff       	call   801029d0 <lapiceoi>
    break;
80105dae:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105db1:	e8 7a dc ff ff       	call   80103a30 <myproc>
80105db6:	85 c0                	test   %eax,%eax
80105db8:	0f 85 8d fe ff ff    	jne    80105c4b <trap+0x4b>
80105dbe:	e9 a5 fe ff ff       	jmp    80105c68 <trap+0x68>
80105dc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dc7:	90                   	nop
    kbdintr();
80105dc8:	e8 c3 ca ff ff       	call   80102890 <kbdintr>
    lapiceoi();
80105dcd:	e8 fe cb ff ff       	call   801029d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dd2:	e8 59 dc ff ff       	call   80103a30 <myproc>
80105dd7:	85 c0                	test   %eax,%eax
80105dd9:	0f 85 6c fe ff ff    	jne    80105c4b <trap+0x4b>
80105ddf:	e9 84 fe ff ff       	jmp    80105c68 <trap+0x68>
80105de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105de8:	e8 43 03 00 00       	call   80106130 <uartintr>
    lapiceoi();
80105ded:	e8 de cb ff ff       	call   801029d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105df2:	e8 39 dc ff ff       	call   80103a30 <myproc>
80105df7:	85 c0                	test   %eax,%eax
80105df9:	0f 85 4c fe ff ff    	jne    80105c4b <trap+0x4b>
80105dff:	e9 64 fe ff ff       	jmp    80105c68 <trap+0x68>
80105e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105e08:	e8 33 c4 ff ff       	call   80102240 <ideintr>
80105e0d:	e9 2b fe ff ff       	jmp    80105c3d <trap+0x3d>
80105e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e18:	0f 20 d7             	mov    %cr2,%edi
    pte_t *pte = walkpgdir(myproc()->pgdir, (void *)va, 0);
80105e1b:	e8 10 dc ff ff       	call   80103a30 <myproc>
80105e20:	83 ec 04             	sub    $0x4,%esp
80105e23:	6a 00                	push   $0x0
80105e25:	57                   	push   %edi
80105e26:	ff 70 04             	push   0x4(%eax)
80105e29:	e8 f2 0f 00 00       	call   80106e20 <walkpgdir>
    if (!pte || !(*pte & PTE_P) || !(*pte & PTE_COW)) {
80105e2e:	83 c4 10             	add    $0x10,%esp
    pte_t *pte = walkpgdir(myproc()->pgdir, (void *)va, 0);
80105e31:	89 c6                	mov    %eax,%esi
    if (!pte || !(*pte & PTE_P) || !(*pte & PTE_COW)) {
80105e33:	85 c0                	test   %eax,%eax
80105e35:	74 12                	je     80105e49 <trap+0x249>
80105e37:	8b 00                	mov    (%eax),%eax
80105e39:	89 c2                	mov    %eax,%edx
80105e3b:	81 e2 01 02 00 00    	and    $0x201,%edx
80105e41:	81 fa 01 02 00 00    	cmp    $0x201,%edx
80105e47:	74 7f                	je     80105ec8 <trap+0x2c8>
      cprintf("PAGEFAULT: invalid access at %x\n", va);
80105e49:	83 ec 08             	sub    $0x8,%esp
80105e4c:	57                   	push   %edi
80105e4d:	68 98 7f 10 80       	push   $0x80107f98
80105e52:	e8 49 a8 ff ff       	call   801006a0 <cprintf>
      myproc()->killed = 1;
80105e57:	e8 d4 db ff ff       	call   80103a30 <myproc>
      return;
80105e5c:	83 c4 10             	add    $0x10,%esp
      myproc()->killed = 1;
80105e5f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      return;
80105e66:	e9 3b fe ff ff       	jmp    80105ca6 <trap+0xa6>
80105e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e6f:	90                   	nop
    exit();
80105e70:	e8 fb e0 ff ff       	call   80103f70 <exit>
80105e75:	e9 ee fd ff ff       	jmp    80105c68 <trap+0x68>
80105e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105e80:	e8 eb e0 ff ff       	call   80103f70 <exit>
80105e85:	e9 d6 fe ff ff       	jmp    80105d60 <trap+0x160>
80105e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105e90:	83 ec 0c             	sub    $0xc,%esp
80105e93:	68 80 cc 14 80       	push   $0x8014cc80
80105e98:	e8 e3 e8 ff ff       	call   80104780 <acquire>
      wakeup(&ticks);
80105e9d:	c7 04 24 60 cc 14 80 	movl   $0x8014cc60,(%esp)
      ticks++;
80105ea4:	83 05 60 cc 14 80 01 	addl   $0x1,0x8014cc60
      wakeup(&ticks);
80105eab:	e8 30 e4 ff ff       	call   801042e0 <wakeup>
      release(&tickslock);
80105eb0:	c7 04 24 80 cc 14 80 	movl   $0x8014cc80,(%esp)
80105eb7:	e8 64 e8 ff ff       	call   80104720 <release>
80105ebc:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105ebf:	e9 79 fd ff ff       	jmp    80105c3d <trap+0x3d>
80105ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uint pa = PTE_ADDR(*pte);
80105ec8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if (get_ref_count(pa) > 1) {
80105ecd:	83 ec 0c             	sub    $0xc,%esp
80105ed0:	50                   	push   %eax
    uint pa = PTE_ADDR(*pte);
80105ed1:	89 c7                	mov    %eax,%edi
    if (get_ref_count(pa) > 1) {
80105ed3:	e8 18 c8 ff ff       	call   801026f0 <get_ref_count>
80105ed8:	83 c4 10             	add    $0x10,%esp
80105edb:	83 f8 01             	cmp    $0x1,%eax
80105ede:	7e 60                	jle    80105f40 <trap+0x340>
      if ((mem = kalloc()) == 0) {
80105ee0:	e8 9b c7 ff ff       	call   80102680 <kalloc>
80105ee5:	89 c2                	mov    %eax,%edx
80105ee7:	85 c0                	test   %eax,%eax
80105ee9:	0f 84 80 00 00 00    	je     80105f6f <trap+0x36f>
      memmove(mem, (char *)P2V(pa), PGSIZE);
80105eef:	83 ec 04             	sub    $0x4,%esp
80105ef2:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80105ef8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80105efb:	68 00 10 00 00       	push   $0x1000
80105f00:	50                   	push   %eax
80105f01:	52                   	push   %edx
80105f02:	e8 d9 e9 ff ff       	call   801048e0 <memmove>
      *pte = V2P(mem) | PTE_P | PTE_W | PTE_U;
80105f07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105f0a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80105f10:	89 d0                	mov    %edx,%eax
80105f12:	83 c8 07             	or     $0x7,%eax
80105f15:	89 06                	mov    %eax,(%esi)
      incr_ref_count(V2P(mem));
80105f17:	89 14 24             	mov    %edx,(%esp)
80105f1a:	e8 01 c8 ff ff       	call   80102720 <incr_ref_count>
      decrement_ref_count(pa);
80105f1f:	89 3c 24             	mov    %edi,(%esp)
80105f22:	e8 39 c8 ff ff       	call   80102760 <decrement_ref_count>
80105f27:	83 c4 10             	add    $0x10,%esp
    lcr3(V2P(myproc()->pgdir));
80105f2a:	e8 01 db ff ff       	call   80103a30 <myproc>
80105f2f:	8b 40 04             	mov    0x4(%eax),%eax
80105f32:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105f37:	0f 22 d8             	mov    %eax,%cr3
}
80105f3a:	e9 03 fd ff ff       	jmp    80105c42 <trap+0x42>
80105f3f:	90                   	nop
    } else if( get_ref_count(pa) == 1) {
80105f40:	83 ec 0c             	sub    $0xc,%esp
80105f43:	57                   	push   %edi
80105f44:	e8 a7 c7 ff ff       	call   801026f0 <get_ref_count>
80105f49:	83 c4 10             	add    $0x10,%esp
80105f4c:	83 f8 01             	cmp    $0x1,%eax
80105f4f:	75 0c                	jne    80105f5d <trap+0x35d>
      *pte &= ~PTE_COW;
80105f51:	8b 06                	mov    (%esi),%eax
80105f53:	80 e4 fd             	and    $0xfd,%ah
80105f56:	83 c8 02             	or     $0x2,%eax
80105f59:	89 06                	mov    %eax,(%esi)
80105f5b:	eb cd                	jmp    80105f2a <trap+0x32a>
      cprintf("Error");
80105f5d:	83 ec 0c             	sub    $0xc,%esp
80105f60:	68 68 7f 10 80       	push   $0x80107f68
80105f65:	e8 36 a7 ff ff       	call   801006a0 <cprintf>
80105f6a:	83 c4 10             	add    $0x10,%esp
80105f6d:	eb bb                	jmp    80105f2a <trap+0x32a>
        cprintf("PAGEFAULT: kalloc failed\n");
80105f6f:	83 ec 0c             	sub    $0xc,%esp
80105f72:	68 4e 7f 10 80       	push   $0x80107f4e
80105f77:	e8 24 a7 ff ff       	call   801006a0 <cprintf>
        myproc()->killed = 1;
80105f7c:	e8 af da ff ff       	call   80103a30 <myproc>
        break;
80105f81:	83 c4 10             	add    $0x10,%esp
        myproc()->killed = 1;
80105f84:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
        break;
80105f8b:	e9 b2 fc ff ff       	jmp    80105c42 <trap+0x42>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f90:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f93:	8b 73 38             	mov    0x38(%ebx),%esi
80105f96:	e8 75 da ff ff       	call   80103a10 <cpuid>
80105f9b:	83 ec 0c             	sub    $0xc,%esp
80105f9e:	57                   	push   %edi
80105f9f:	56                   	push   %esi
80105fa0:	50                   	push   %eax
80105fa1:	ff 73 30             	push   0x30(%ebx)
80105fa4:	68 bc 7f 10 80       	push   $0x80107fbc
80105fa9:	e8 f2 a6 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105fae:	83 c4 14             	add    $0x14,%esp
80105fb1:	68 6e 7f 10 80       	push   $0x80107f6e
80105fb6:	e8 c5 a3 ff ff       	call   80100380 <panic>
80105fbb:	66 90                	xchg   %ax,%ax
80105fbd:	66 90                	xchg   %ax,%ax
80105fbf:	90                   	nop

80105fc0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105fc0:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
80105fc5:	85 c0                	test   %eax,%eax
80105fc7:	74 17                	je     80105fe0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fc9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fce:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105fcf:	a8 01                	test   $0x1,%al
80105fd1:	74 0d                	je     80105fe0 <uartgetc+0x20>
80105fd3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fd8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105fd9:	0f b6 c0             	movzbl %al,%eax
80105fdc:	c3                   	ret    
80105fdd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fe5:	c3                   	ret    
80105fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fed:	8d 76 00             	lea    0x0(%esi),%esi

80105ff0 <uartinit>:
{
80105ff0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ff1:	31 c9                	xor    %ecx,%ecx
80105ff3:	89 c8                	mov    %ecx,%eax
80105ff5:	89 e5                	mov    %esp,%ebp
80105ff7:	57                   	push   %edi
80105ff8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105ffd:	56                   	push   %esi
80105ffe:	89 fa                	mov    %edi,%edx
80106000:	53                   	push   %ebx
80106001:	83 ec 1c             	sub    $0x1c,%esp
80106004:	ee                   	out    %al,(%dx)
80106005:	be fb 03 00 00       	mov    $0x3fb,%esi
8010600a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010600f:	89 f2                	mov    %esi,%edx
80106011:	ee                   	out    %al,(%dx)
80106012:	b8 0c 00 00 00       	mov    $0xc,%eax
80106017:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010601c:	ee                   	out    %al,(%dx)
8010601d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106022:	89 c8                	mov    %ecx,%eax
80106024:	89 da                	mov    %ebx,%edx
80106026:	ee                   	out    %al,(%dx)
80106027:	b8 03 00 00 00       	mov    $0x3,%eax
8010602c:	89 f2                	mov    %esi,%edx
8010602e:	ee                   	out    %al,(%dx)
8010602f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106034:	89 c8                	mov    %ecx,%eax
80106036:	ee                   	out    %al,(%dx)
80106037:	b8 01 00 00 00       	mov    $0x1,%eax
8010603c:	89 da                	mov    %ebx,%edx
8010603e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010603f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106044:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106045:	3c ff                	cmp    $0xff,%al
80106047:	74 78                	je     801060c1 <uartinit+0xd1>
  uart = 1;
80106049:	c7 05 c0 d4 14 80 01 	movl   $0x1,0x8014d4c0
80106050:	00 00 00 
80106053:	89 fa                	mov    %edi,%edx
80106055:	ec                   	in     (%dx),%al
80106056:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010605b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010605c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010605f:	bf fc 80 10 80       	mov    $0x801080fc,%edi
80106064:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106069:	6a 00                	push   $0x0
8010606b:	6a 04                	push   $0x4
8010606d:	e8 0e c4 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106072:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106076:	83 c4 10             	add    $0x10,%esp
80106079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106080:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
80106085:	bb 80 00 00 00       	mov    $0x80,%ebx
8010608a:	85 c0                	test   %eax,%eax
8010608c:	75 14                	jne    801060a2 <uartinit+0xb2>
8010608e:	eb 23                	jmp    801060b3 <uartinit+0xc3>
    microdelay(10);
80106090:	83 ec 0c             	sub    $0xc,%esp
80106093:	6a 0a                	push   $0xa
80106095:	e8 56 c9 ff ff       	call   801029f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010609a:	83 c4 10             	add    $0x10,%esp
8010609d:	83 eb 01             	sub    $0x1,%ebx
801060a0:	74 07                	je     801060a9 <uartinit+0xb9>
801060a2:	89 f2                	mov    %esi,%edx
801060a4:	ec                   	in     (%dx),%al
801060a5:	a8 20                	test   $0x20,%al
801060a7:	74 e7                	je     80106090 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060a9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801060ad:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060b2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801060b3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801060b7:	83 c7 01             	add    $0x1,%edi
801060ba:	88 45 e7             	mov    %al,-0x19(%ebp)
801060bd:	84 c0                	test   %al,%al
801060bf:	75 bf                	jne    80106080 <uartinit+0x90>
}
801060c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060c4:	5b                   	pop    %ebx
801060c5:	5e                   	pop    %esi
801060c6:	5f                   	pop    %edi
801060c7:	5d                   	pop    %ebp
801060c8:	c3                   	ret    
801060c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060d0 <uartputc>:
  if(!uart)
801060d0:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
801060d5:	85 c0                	test   %eax,%eax
801060d7:	74 47                	je     80106120 <uartputc+0x50>
{
801060d9:	55                   	push   %ebp
801060da:	89 e5                	mov    %esp,%ebp
801060dc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060dd:	be fd 03 00 00       	mov    $0x3fd,%esi
801060e2:	53                   	push   %ebx
801060e3:	bb 80 00 00 00       	mov    $0x80,%ebx
801060e8:	eb 18                	jmp    80106102 <uartputc+0x32>
801060ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801060f0:	83 ec 0c             	sub    $0xc,%esp
801060f3:	6a 0a                	push   $0xa
801060f5:	e8 f6 c8 ff ff       	call   801029f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060fa:	83 c4 10             	add    $0x10,%esp
801060fd:	83 eb 01             	sub    $0x1,%ebx
80106100:	74 07                	je     80106109 <uartputc+0x39>
80106102:	89 f2                	mov    %esi,%edx
80106104:	ec                   	in     (%dx),%al
80106105:	a8 20                	test   $0x20,%al
80106107:	74 e7                	je     801060f0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106109:	8b 45 08             	mov    0x8(%ebp),%eax
8010610c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106111:	ee                   	out    %al,(%dx)
}
80106112:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106115:	5b                   	pop    %ebx
80106116:	5e                   	pop    %esi
80106117:	5d                   	pop    %ebp
80106118:	c3                   	ret    
80106119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106120:	c3                   	ret    
80106121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010612f:	90                   	nop

80106130 <uartintr>:

void
uartintr(void)
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106136:	68 c0 5f 10 80       	push   $0x80105fc0
8010613b:	e8 40 a7 ff ff       	call   80100880 <consoleintr>
}
80106140:	83 c4 10             	add    $0x10,%esp
80106143:	c9                   	leave  
80106144:	c3                   	ret    

80106145 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $0
80106147:	6a 00                	push   $0x0
  jmp alltraps
80106149:	e9 d1 f9 ff ff       	jmp    80105b1f <alltraps>

8010614e <vector1>:
.globl vector1
vector1:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $1
80106150:	6a 01                	push   $0x1
  jmp alltraps
80106152:	e9 c8 f9 ff ff       	jmp    80105b1f <alltraps>

80106157 <vector2>:
.globl vector2
vector2:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $2
80106159:	6a 02                	push   $0x2
  jmp alltraps
8010615b:	e9 bf f9 ff ff       	jmp    80105b1f <alltraps>

80106160 <vector3>:
.globl vector3
vector3:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $3
80106162:	6a 03                	push   $0x3
  jmp alltraps
80106164:	e9 b6 f9 ff ff       	jmp    80105b1f <alltraps>

80106169 <vector4>:
.globl vector4
vector4:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $4
8010616b:	6a 04                	push   $0x4
  jmp alltraps
8010616d:	e9 ad f9 ff ff       	jmp    80105b1f <alltraps>

80106172 <vector5>:
.globl vector5
vector5:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $5
80106174:	6a 05                	push   $0x5
  jmp alltraps
80106176:	e9 a4 f9 ff ff       	jmp    80105b1f <alltraps>

8010617b <vector6>:
.globl vector6
vector6:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $6
8010617d:	6a 06                	push   $0x6
  jmp alltraps
8010617f:	e9 9b f9 ff ff       	jmp    80105b1f <alltraps>

80106184 <vector7>:
.globl vector7
vector7:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $7
80106186:	6a 07                	push   $0x7
  jmp alltraps
80106188:	e9 92 f9 ff ff       	jmp    80105b1f <alltraps>

8010618d <vector8>:
.globl vector8
vector8:
  pushl $8
8010618d:	6a 08                	push   $0x8
  jmp alltraps
8010618f:	e9 8b f9 ff ff       	jmp    80105b1f <alltraps>

80106194 <vector9>:
.globl vector9
vector9:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $9
80106196:	6a 09                	push   $0x9
  jmp alltraps
80106198:	e9 82 f9 ff ff       	jmp    80105b1f <alltraps>

8010619d <vector10>:
.globl vector10
vector10:
  pushl $10
8010619d:	6a 0a                	push   $0xa
  jmp alltraps
8010619f:	e9 7b f9 ff ff       	jmp    80105b1f <alltraps>

801061a4 <vector11>:
.globl vector11
vector11:
  pushl $11
801061a4:	6a 0b                	push   $0xb
  jmp alltraps
801061a6:	e9 74 f9 ff ff       	jmp    80105b1f <alltraps>

801061ab <vector12>:
.globl vector12
vector12:
  pushl $12
801061ab:	6a 0c                	push   $0xc
  jmp alltraps
801061ad:	e9 6d f9 ff ff       	jmp    80105b1f <alltraps>

801061b2 <vector13>:
.globl vector13
vector13:
  pushl $13
801061b2:	6a 0d                	push   $0xd
  jmp alltraps
801061b4:	e9 66 f9 ff ff       	jmp    80105b1f <alltraps>

801061b9 <vector14>:
.globl vector14
vector14:
  pushl $14
801061b9:	6a 0e                	push   $0xe
  jmp alltraps
801061bb:	e9 5f f9 ff ff       	jmp    80105b1f <alltraps>

801061c0 <vector15>:
.globl vector15
vector15:
  pushl $0
801061c0:	6a 00                	push   $0x0
  pushl $15
801061c2:	6a 0f                	push   $0xf
  jmp alltraps
801061c4:	e9 56 f9 ff ff       	jmp    80105b1f <alltraps>

801061c9 <vector16>:
.globl vector16
vector16:
  pushl $0
801061c9:	6a 00                	push   $0x0
  pushl $16
801061cb:	6a 10                	push   $0x10
  jmp alltraps
801061cd:	e9 4d f9 ff ff       	jmp    80105b1f <alltraps>

801061d2 <vector17>:
.globl vector17
vector17:
  pushl $17
801061d2:	6a 11                	push   $0x11
  jmp alltraps
801061d4:	e9 46 f9 ff ff       	jmp    80105b1f <alltraps>

801061d9 <vector18>:
.globl vector18
vector18:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $18
801061db:	6a 12                	push   $0x12
  jmp alltraps
801061dd:	e9 3d f9 ff ff       	jmp    80105b1f <alltraps>

801061e2 <vector19>:
.globl vector19
vector19:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $19
801061e4:	6a 13                	push   $0x13
  jmp alltraps
801061e6:	e9 34 f9 ff ff       	jmp    80105b1f <alltraps>

801061eb <vector20>:
.globl vector20
vector20:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $20
801061ed:	6a 14                	push   $0x14
  jmp alltraps
801061ef:	e9 2b f9 ff ff       	jmp    80105b1f <alltraps>

801061f4 <vector21>:
.globl vector21
vector21:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $21
801061f6:	6a 15                	push   $0x15
  jmp alltraps
801061f8:	e9 22 f9 ff ff       	jmp    80105b1f <alltraps>

801061fd <vector22>:
.globl vector22
vector22:
  pushl $0
801061fd:	6a 00                	push   $0x0
  pushl $22
801061ff:	6a 16                	push   $0x16
  jmp alltraps
80106201:	e9 19 f9 ff ff       	jmp    80105b1f <alltraps>

80106206 <vector23>:
.globl vector23
vector23:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $23
80106208:	6a 17                	push   $0x17
  jmp alltraps
8010620a:	e9 10 f9 ff ff       	jmp    80105b1f <alltraps>

8010620f <vector24>:
.globl vector24
vector24:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $24
80106211:	6a 18                	push   $0x18
  jmp alltraps
80106213:	e9 07 f9 ff ff       	jmp    80105b1f <alltraps>

80106218 <vector25>:
.globl vector25
vector25:
  pushl $0
80106218:	6a 00                	push   $0x0
  pushl $25
8010621a:	6a 19                	push   $0x19
  jmp alltraps
8010621c:	e9 fe f8 ff ff       	jmp    80105b1f <alltraps>

80106221 <vector26>:
.globl vector26
vector26:
  pushl $0
80106221:	6a 00                	push   $0x0
  pushl $26
80106223:	6a 1a                	push   $0x1a
  jmp alltraps
80106225:	e9 f5 f8 ff ff       	jmp    80105b1f <alltraps>

8010622a <vector27>:
.globl vector27
vector27:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $27
8010622c:	6a 1b                	push   $0x1b
  jmp alltraps
8010622e:	e9 ec f8 ff ff       	jmp    80105b1f <alltraps>

80106233 <vector28>:
.globl vector28
vector28:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $28
80106235:	6a 1c                	push   $0x1c
  jmp alltraps
80106237:	e9 e3 f8 ff ff       	jmp    80105b1f <alltraps>

8010623c <vector29>:
.globl vector29
vector29:
  pushl $0
8010623c:	6a 00                	push   $0x0
  pushl $29
8010623e:	6a 1d                	push   $0x1d
  jmp alltraps
80106240:	e9 da f8 ff ff       	jmp    80105b1f <alltraps>

80106245 <vector30>:
.globl vector30
vector30:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $30
80106247:	6a 1e                	push   $0x1e
  jmp alltraps
80106249:	e9 d1 f8 ff ff       	jmp    80105b1f <alltraps>

8010624e <vector31>:
.globl vector31
vector31:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $31
80106250:	6a 1f                	push   $0x1f
  jmp alltraps
80106252:	e9 c8 f8 ff ff       	jmp    80105b1f <alltraps>

80106257 <vector32>:
.globl vector32
vector32:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $32
80106259:	6a 20                	push   $0x20
  jmp alltraps
8010625b:	e9 bf f8 ff ff       	jmp    80105b1f <alltraps>

80106260 <vector33>:
.globl vector33
vector33:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $33
80106262:	6a 21                	push   $0x21
  jmp alltraps
80106264:	e9 b6 f8 ff ff       	jmp    80105b1f <alltraps>

80106269 <vector34>:
.globl vector34
vector34:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $34
8010626b:	6a 22                	push   $0x22
  jmp alltraps
8010626d:	e9 ad f8 ff ff       	jmp    80105b1f <alltraps>

80106272 <vector35>:
.globl vector35
vector35:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $35
80106274:	6a 23                	push   $0x23
  jmp alltraps
80106276:	e9 a4 f8 ff ff       	jmp    80105b1f <alltraps>

8010627b <vector36>:
.globl vector36
vector36:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $36
8010627d:	6a 24                	push   $0x24
  jmp alltraps
8010627f:	e9 9b f8 ff ff       	jmp    80105b1f <alltraps>

80106284 <vector37>:
.globl vector37
vector37:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $37
80106286:	6a 25                	push   $0x25
  jmp alltraps
80106288:	e9 92 f8 ff ff       	jmp    80105b1f <alltraps>

8010628d <vector38>:
.globl vector38
vector38:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $38
8010628f:	6a 26                	push   $0x26
  jmp alltraps
80106291:	e9 89 f8 ff ff       	jmp    80105b1f <alltraps>

80106296 <vector39>:
.globl vector39
vector39:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $39
80106298:	6a 27                	push   $0x27
  jmp alltraps
8010629a:	e9 80 f8 ff ff       	jmp    80105b1f <alltraps>

8010629f <vector40>:
.globl vector40
vector40:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $40
801062a1:	6a 28                	push   $0x28
  jmp alltraps
801062a3:	e9 77 f8 ff ff       	jmp    80105b1f <alltraps>

801062a8 <vector41>:
.globl vector41
vector41:
  pushl $0
801062a8:	6a 00                	push   $0x0
  pushl $41
801062aa:	6a 29                	push   $0x29
  jmp alltraps
801062ac:	e9 6e f8 ff ff       	jmp    80105b1f <alltraps>

801062b1 <vector42>:
.globl vector42
vector42:
  pushl $0
801062b1:	6a 00                	push   $0x0
  pushl $42
801062b3:	6a 2a                	push   $0x2a
  jmp alltraps
801062b5:	e9 65 f8 ff ff       	jmp    80105b1f <alltraps>

801062ba <vector43>:
.globl vector43
vector43:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $43
801062bc:	6a 2b                	push   $0x2b
  jmp alltraps
801062be:	e9 5c f8 ff ff       	jmp    80105b1f <alltraps>

801062c3 <vector44>:
.globl vector44
vector44:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $44
801062c5:	6a 2c                	push   $0x2c
  jmp alltraps
801062c7:	e9 53 f8 ff ff       	jmp    80105b1f <alltraps>

801062cc <vector45>:
.globl vector45
vector45:
  pushl $0
801062cc:	6a 00                	push   $0x0
  pushl $45
801062ce:	6a 2d                	push   $0x2d
  jmp alltraps
801062d0:	e9 4a f8 ff ff       	jmp    80105b1f <alltraps>

801062d5 <vector46>:
.globl vector46
vector46:
  pushl $0
801062d5:	6a 00                	push   $0x0
  pushl $46
801062d7:	6a 2e                	push   $0x2e
  jmp alltraps
801062d9:	e9 41 f8 ff ff       	jmp    80105b1f <alltraps>

801062de <vector47>:
.globl vector47
vector47:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $47
801062e0:	6a 2f                	push   $0x2f
  jmp alltraps
801062e2:	e9 38 f8 ff ff       	jmp    80105b1f <alltraps>

801062e7 <vector48>:
.globl vector48
vector48:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $48
801062e9:	6a 30                	push   $0x30
  jmp alltraps
801062eb:	e9 2f f8 ff ff       	jmp    80105b1f <alltraps>

801062f0 <vector49>:
.globl vector49
vector49:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $49
801062f2:	6a 31                	push   $0x31
  jmp alltraps
801062f4:	e9 26 f8 ff ff       	jmp    80105b1f <alltraps>

801062f9 <vector50>:
.globl vector50
vector50:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $50
801062fb:	6a 32                	push   $0x32
  jmp alltraps
801062fd:	e9 1d f8 ff ff       	jmp    80105b1f <alltraps>

80106302 <vector51>:
.globl vector51
vector51:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $51
80106304:	6a 33                	push   $0x33
  jmp alltraps
80106306:	e9 14 f8 ff ff       	jmp    80105b1f <alltraps>

8010630b <vector52>:
.globl vector52
vector52:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $52
8010630d:	6a 34                	push   $0x34
  jmp alltraps
8010630f:	e9 0b f8 ff ff       	jmp    80105b1f <alltraps>

80106314 <vector53>:
.globl vector53
vector53:
  pushl $0
80106314:	6a 00                	push   $0x0
  pushl $53
80106316:	6a 35                	push   $0x35
  jmp alltraps
80106318:	e9 02 f8 ff ff       	jmp    80105b1f <alltraps>

8010631d <vector54>:
.globl vector54
vector54:
  pushl $0
8010631d:	6a 00                	push   $0x0
  pushl $54
8010631f:	6a 36                	push   $0x36
  jmp alltraps
80106321:	e9 f9 f7 ff ff       	jmp    80105b1f <alltraps>

80106326 <vector55>:
.globl vector55
vector55:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $55
80106328:	6a 37                	push   $0x37
  jmp alltraps
8010632a:	e9 f0 f7 ff ff       	jmp    80105b1f <alltraps>

8010632f <vector56>:
.globl vector56
vector56:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $56
80106331:	6a 38                	push   $0x38
  jmp alltraps
80106333:	e9 e7 f7 ff ff       	jmp    80105b1f <alltraps>

80106338 <vector57>:
.globl vector57
vector57:
  pushl $0
80106338:	6a 00                	push   $0x0
  pushl $57
8010633a:	6a 39                	push   $0x39
  jmp alltraps
8010633c:	e9 de f7 ff ff       	jmp    80105b1f <alltraps>

80106341 <vector58>:
.globl vector58
vector58:
  pushl $0
80106341:	6a 00                	push   $0x0
  pushl $58
80106343:	6a 3a                	push   $0x3a
  jmp alltraps
80106345:	e9 d5 f7 ff ff       	jmp    80105b1f <alltraps>

8010634a <vector59>:
.globl vector59
vector59:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $59
8010634c:	6a 3b                	push   $0x3b
  jmp alltraps
8010634e:	e9 cc f7 ff ff       	jmp    80105b1f <alltraps>

80106353 <vector60>:
.globl vector60
vector60:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $60
80106355:	6a 3c                	push   $0x3c
  jmp alltraps
80106357:	e9 c3 f7 ff ff       	jmp    80105b1f <alltraps>

8010635c <vector61>:
.globl vector61
vector61:
  pushl $0
8010635c:	6a 00                	push   $0x0
  pushl $61
8010635e:	6a 3d                	push   $0x3d
  jmp alltraps
80106360:	e9 ba f7 ff ff       	jmp    80105b1f <alltraps>

80106365 <vector62>:
.globl vector62
vector62:
  pushl $0
80106365:	6a 00                	push   $0x0
  pushl $62
80106367:	6a 3e                	push   $0x3e
  jmp alltraps
80106369:	e9 b1 f7 ff ff       	jmp    80105b1f <alltraps>

8010636e <vector63>:
.globl vector63
vector63:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $63
80106370:	6a 3f                	push   $0x3f
  jmp alltraps
80106372:	e9 a8 f7 ff ff       	jmp    80105b1f <alltraps>

80106377 <vector64>:
.globl vector64
vector64:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $64
80106379:	6a 40                	push   $0x40
  jmp alltraps
8010637b:	e9 9f f7 ff ff       	jmp    80105b1f <alltraps>

80106380 <vector65>:
.globl vector65
vector65:
  pushl $0
80106380:	6a 00                	push   $0x0
  pushl $65
80106382:	6a 41                	push   $0x41
  jmp alltraps
80106384:	e9 96 f7 ff ff       	jmp    80105b1f <alltraps>

80106389 <vector66>:
.globl vector66
vector66:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $66
8010638b:	6a 42                	push   $0x42
  jmp alltraps
8010638d:	e9 8d f7 ff ff       	jmp    80105b1f <alltraps>

80106392 <vector67>:
.globl vector67
vector67:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $67
80106394:	6a 43                	push   $0x43
  jmp alltraps
80106396:	e9 84 f7 ff ff       	jmp    80105b1f <alltraps>

8010639b <vector68>:
.globl vector68
vector68:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $68
8010639d:	6a 44                	push   $0x44
  jmp alltraps
8010639f:	e9 7b f7 ff ff       	jmp    80105b1f <alltraps>

801063a4 <vector69>:
.globl vector69
vector69:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $69
801063a6:	6a 45                	push   $0x45
  jmp alltraps
801063a8:	e9 72 f7 ff ff       	jmp    80105b1f <alltraps>

801063ad <vector70>:
.globl vector70
vector70:
  pushl $0
801063ad:	6a 00                	push   $0x0
  pushl $70
801063af:	6a 46                	push   $0x46
  jmp alltraps
801063b1:	e9 69 f7 ff ff       	jmp    80105b1f <alltraps>

801063b6 <vector71>:
.globl vector71
vector71:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $71
801063b8:	6a 47                	push   $0x47
  jmp alltraps
801063ba:	e9 60 f7 ff ff       	jmp    80105b1f <alltraps>

801063bf <vector72>:
.globl vector72
vector72:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $72
801063c1:	6a 48                	push   $0x48
  jmp alltraps
801063c3:	e9 57 f7 ff ff       	jmp    80105b1f <alltraps>

801063c8 <vector73>:
.globl vector73
vector73:
  pushl $0
801063c8:	6a 00                	push   $0x0
  pushl $73
801063ca:	6a 49                	push   $0x49
  jmp alltraps
801063cc:	e9 4e f7 ff ff       	jmp    80105b1f <alltraps>

801063d1 <vector74>:
.globl vector74
vector74:
  pushl $0
801063d1:	6a 00                	push   $0x0
  pushl $74
801063d3:	6a 4a                	push   $0x4a
  jmp alltraps
801063d5:	e9 45 f7 ff ff       	jmp    80105b1f <alltraps>

801063da <vector75>:
.globl vector75
vector75:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $75
801063dc:	6a 4b                	push   $0x4b
  jmp alltraps
801063de:	e9 3c f7 ff ff       	jmp    80105b1f <alltraps>

801063e3 <vector76>:
.globl vector76
vector76:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $76
801063e5:	6a 4c                	push   $0x4c
  jmp alltraps
801063e7:	e9 33 f7 ff ff       	jmp    80105b1f <alltraps>

801063ec <vector77>:
.globl vector77
vector77:
  pushl $0
801063ec:	6a 00                	push   $0x0
  pushl $77
801063ee:	6a 4d                	push   $0x4d
  jmp alltraps
801063f0:	e9 2a f7 ff ff       	jmp    80105b1f <alltraps>

801063f5 <vector78>:
.globl vector78
vector78:
  pushl $0
801063f5:	6a 00                	push   $0x0
  pushl $78
801063f7:	6a 4e                	push   $0x4e
  jmp alltraps
801063f9:	e9 21 f7 ff ff       	jmp    80105b1f <alltraps>

801063fe <vector79>:
.globl vector79
vector79:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $79
80106400:	6a 4f                	push   $0x4f
  jmp alltraps
80106402:	e9 18 f7 ff ff       	jmp    80105b1f <alltraps>

80106407 <vector80>:
.globl vector80
vector80:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $80
80106409:	6a 50                	push   $0x50
  jmp alltraps
8010640b:	e9 0f f7 ff ff       	jmp    80105b1f <alltraps>

80106410 <vector81>:
.globl vector81
vector81:
  pushl $0
80106410:	6a 00                	push   $0x0
  pushl $81
80106412:	6a 51                	push   $0x51
  jmp alltraps
80106414:	e9 06 f7 ff ff       	jmp    80105b1f <alltraps>

80106419 <vector82>:
.globl vector82
vector82:
  pushl $0
80106419:	6a 00                	push   $0x0
  pushl $82
8010641b:	6a 52                	push   $0x52
  jmp alltraps
8010641d:	e9 fd f6 ff ff       	jmp    80105b1f <alltraps>

80106422 <vector83>:
.globl vector83
vector83:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $83
80106424:	6a 53                	push   $0x53
  jmp alltraps
80106426:	e9 f4 f6 ff ff       	jmp    80105b1f <alltraps>

8010642b <vector84>:
.globl vector84
vector84:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $84
8010642d:	6a 54                	push   $0x54
  jmp alltraps
8010642f:	e9 eb f6 ff ff       	jmp    80105b1f <alltraps>

80106434 <vector85>:
.globl vector85
vector85:
  pushl $0
80106434:	6a 00                	push   $0x0
  pushl $85
80106436:	6a 55                	push   $0x55
  jmp alltraps
80106438:	e9 e2 f6 ff ff       	jmp    80105b1f <alltraps>

8010643d <vector86>:
.globl vector86
vector86:
  pushl $0
8010643d:	6a 00                	push   $0x0
  pushl $86
8010643f:	6a 56                	push   $0x56
  jmp alltraps
80106441:	e9 d9 f6 ff ff       	jmp    80105b1f <alltraps>

80106446 <vector87>:
.globl vector87
vector87:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $87
80106448:	6a 57                	push   $0x57
  jmp alltraps
8010644a:	e9 d0 f6 ff ff       	jmp    80105b1f <alltraps>

8010644f <vector88>:
.globl vector88
vector88:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $88
80106451:	6a 58                	push   $0x58
  jmp alltraps
80106453:	e9 c7 f6 ff ff       	jmp    80105b1f <alltraps>

80106458 <vector89>:
.globl vector89
vector89:
  pushl $0
80106458:	6a 00                	push   $0x0
  pushl $89
8010645a:	6a 59                	push   $0x59
  jmp alltraps
8010645c:	e9 be f6 ff ff       	jmp    80105b1f <alltraps>

80106461 <vector90>:
.globl vector90
vector90:
  pushl $0
80106461:	6a 00                	push   $0x0
  pushl $90
80106463:	6a 5a                	push   $0x5a
  jmp alltraps
80106465:	e9 b5 f6 ff ff       	jmp    80105b1f <alltraps>

8010646a <vector91>:
.globl vector91
vector91:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $91
8010646c:	6a 5b                	push   $0x5b
  jmp alltraps
8010646e:	e9 ac f6 ff ff       	jmp    80105b1f <alltraps>

80106473 <vector92>:
.globl vector92
vector92:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $92
80106475:	6a 5c                	push   $0x5c
  jmp alltraps
80106477:	e9 a3 f6 ff ff       	jmp    80105b1f <alltraps>

8010647c <vector93>:
.globl vector93
vector93:
  pushl $0
8010647c:	6a 00                	push   $0x0
  pushl $93
8010647e:	6a 5d                	push   $0x5d
  jmp alltraps
80106480:	e9 9a f6 ff ff       	jmp    80105b1f <alltraps>

80106485 <vector94>:
.globl vector94
vector94:
  pushl $0
80106485:	6a 00                	push   $0x0
  pushl $94
80106487:	6a 5e                	push   $0x5e
  jmp alltraps
80106489:	e9 91 f6 ff ff       	jmp    80105b1f <alltraps>

8010648e <vector95>:
.globl vector95
vector95:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $95
80106490:	6a 5f                	push   $0x5f
  jmp alltraps
80106492:	e9 88 f6 ff ff       	jmp    80105b1f <alltraps>

80106497 <vector96>:
.globl vector96
vector96:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $96
80106499:	6a 60                	push   $0x60
  jmp alltraps
8010649b:	e9 7f f6 ff ff       	jmp    80105b1f <alltraps>

801064a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801064a0:	6a 00                	push   $0x0
  pushl $97
801064a2:	6a 61                	push   $0x61
  jmp alltraps
801064a4:	e9 76 f6 ff ff       	jmp    80105b1f <alltraps>

801064a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801064a9:	6a 00                	push   $0x0
  pushl $98
801064ab:	6a 62                	push   $0x62
  jmp alltraps
801064ad:	e9 6d f6 ff ff       	jmp    80105b1f <alltraps>

801064b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $99
801064b4:	6a 63                	push   $0x63
  jmp alltraps
801064b6:	e9 64 f6 ff ff       	jmp    80105b1f <alltraps>

801064bb <vector100>:
.globl vector100
vector100:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $100
801064bd:	6a 64                	push   $0x64
  jmp alltraps
801064bf:	e9 5b f6 ff ff       	jmp    80105b1f <alltraps>

801064c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801064c4:	6a 00                	push   $0x0
  pushl $101
801064c6:	6a 65                	push   $0x65
  jmp alltraps
801064c8:	e9 52 f6 ff ff       	jmp    80105b1f <alltraps>

801064cd <vector102>:
.globl vector102
vector102:
  pushl $0
801064cd:	6a 00                	push   $0x0
  pushl $102
801064cf:	6a 66                	push   $0x66
  jmp alltraps
801064d1:	e9 49 f6 ff ff       	jmp    80105b1f <alltraps>

801064d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $103
801064d8:	6a 67                	push   $0x67
  jmp alltraps
801064da:	e9 40 f6 ff ff       	jmp    80105b1f <alltraps>

801064df <vector104>:
.globl vector104
vector104:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $104
801064e1:	6a 68                	push   $0x68
  jmp alltraps
801064e3:	e9 37 f6 ff ff       	jmp    80105b1f <alltraps>

801064e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801064e8:	6a 00                	push   $0x0
  pushl $105
801064ea:	6a 69                	push   $0x69
  jmp alltraps
801064ec:	e9 2e f6 ff ff       	jmp    80105b1f <alltraps>

801064f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801064f1:	6a 00                	push   $0x0
  pushl $106
801064f3:	6a 6a                	push   $0x6a
  jmp alltraps
801064f5:	e9 25 f6 ff ff       	jmp    80105b1f <alltraps>

801064fa <vector107>:
.globl vector107
vector107:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $107
801064fc:	6a 6b                	push   $0x6b
  jmp alltraps
801064fe:	e9 1c f6 ff ff       	jmp    80105b1f <alltraps>

80106503 <vector108>:
.globl vector108
vector108:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $108
80106505:	6a 6c                	push   $0x6c
  jmp alltraps
80106507:	e9 13 f6 ff ff       	jmp    80105b1f <alltraps>

8010650c <vector109>:
.globl vector109
vector109:
  pushl $0
8010650c:	6a 00                	push   $0x0
  pushl $109
8010650e:	6a 6d                	push   $0x6d
  jmp alltraps
80106510:	e9 0a f6 ff ff       	jmp    80105b1f <alltraps>

80106515 <vector110>:
.globl vector110
vector110:
  pushl $0
80106515:	6a 00                	push   $0x0
  pushl $110
80106517:	6a 6e                	push   $0x6e
  jmp alltraps
80106519:	e9 01 f6 ff ff       	jmp    80105b1f <alltraps>

8010651e <vector111>:
.globl vector111
vector111:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $111
80106520:	6a 6f                	push   $0x6f
  jmp alltraps
80106522:	e9 f8 f5 ff ff       	jmp    80105b1f <alltraps>

80106527 <vector112>:
.globl vector112
vector112:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $112
80106529:	6a 70                	push   $0x70
  jmp alltraps
8010652b:	e9 ef f5 ff ff       	jmp    80105b1f <alltraps>

80106530 <vector113>:
.globl vector113
vector113:
  pushl $0
80106530:	6a 00                	push   $0x0
  pushl $113
80106532:	6a 71                	push   $0x71
  jmp alltraps
80106534:	e9 e6 f5 ff ff       	jmp    80105b1f <alltraps>

80106539 <vector114>:
.globl vector114
vector114:
  pushl $0
80106539:	6a 00                	push   $0x0
  pushl $114
8010653b:	6a 72                	push   $0x72
  jmp alltraps
8010653d:	e9 dd f5 ff ff       	jmp    80105b1f <alltraps>

80106542 <vector115>:
.globl vector115
vector115:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $115
80106544:	6a 73                	push   $0x73
  jmp alltraps
80106546:	e9 d4 f5 ff ff       	jmp    80105b1f <alltraps>

8010654b <vector116>:
.globl vector116
vector116:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $116
8010654d:	6a 74                	push   $0x74
  jmp alltraps
8010654f:	e9 cb f5 ff ff       	jmp    80105b1f <alltraps>

80106554 <vector117>:
.globl vector117
vector117:
  pushl $0
80106554:	6a 00                	push   $0x0
  pushl $117
80106556:	6a 75                	push   $0x75
  jmp alltraps
80106558:	e9 c2 f5 ff ff       	jmp    80105b1f <alltraps>

8010655d <vector118>:
.globl vector118
vector118:
  pushl $0
8010655d:	6a 00                	push   $0x0
  pushl $118
8010655f:	6a 76                	push   $0x76
  jmp alltraps
80106561:	e9 b9 f5 ff ff       	jmp    80105b1f <alltraps>

80106566 <vector119>:
.globl vector119
vector119:
  pushl $0
80106566:	6a 00                	push   $0x0
  pushl $119
80106568:	6a 77                	push   $0x77
  jmp alltraps
8010656a:	e9 b0 f5 ff ff       	jmp    80105b1f <alltraps>

8010656f <vector120>:
.globl vector120
vector120:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $120
80106571:	6a 78                	push   $0x78
  jmp alltraps
80106573:	e9 a7 f5 ff ff       	jmp    80105b1f <alltraps>

80106578 <vector121>:
.globl vector121
vector121:
  pushl $0
80106578:	6a 00                	push   $0x0
  pushl $121
8010657a:	6a 79                	push   $0x79
  jmp alltraps
8010657c:	e9 9e f5 ff ff       	jmp    80105b1f <alltraps>

80106581 <vector122>:
.globl vector122
vector122:
  pushl $0
80106581:	6a 00                	push   $0x0
  pushl $122
80106583:	6a 7a                	push   $0x7a
  jmp alltraps
80106585:	e9 95 f5 ff ff       	jmp    80105b1f <alltraps>

8010658a <vector123>:
.globl vector123
vector123:
  pushl $0
8010658a:	6a 00                	push   $0x0
  pushl $123
8010658c:	6a 7b                	push   $0x7b
  jmp alltraps
8010658e:	e9 8c f5 ff ff       	jmp    80105b1f <alltraps>

80106593 <vector124>:
.globl vector124
vector124:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $124
80106595:	6a 7c                	push   $0x7c
  jmp alltraps
80106597:	e9 83 f5 ff ff       	jmp    80105b1f <alltraps>

8010659c <vector125>:
.globl vector125
vector125:
  pushl $0
8010659c:	6a 00                	push   $0x0
  pushl $125
8010659e:	6a 7d                	push   $0x7d
  jmp alltraps
801065a0:	e9 7a f5 ff ff       	jmp    80105b1f <alltraps>

801065a5 <vector126>:
.globl vector126
vector126:
  pushl $0
801065a5:	6a 00                	push   $0x0
  pushl $126
801065a7:	6a 7e                	push   $0x7e
  jmp alltraps
801065a9:	e9 71 f5 ff ff       	jmp    80105b1f <alltraps>

801065ae <vector127>:
.globl vector127
vector127:
  pushl $0
801065ae:	6a 00                	push   $0x0
  pushl $127
801065b0:	6a 7f                	push   $0x7f
  jmp alltraps
801065b2:	e9 68 f5 ff ff       	jmp    80105b1f <alltraps>

801065b7 <vector128>:
.globl vector128
vector128:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $128
801065b9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801065be:	e9 5c f5 ff ff       	jmp    80105b1f <alltraps>

801065c3 <vector129>:
.globl vector129
vector129:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $129
801065c5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801065ca:	e9 50 f5 ff ff       	jmp    80105b1f <alltraps>

801065cf <vector130>:
.globl vector130
vector130:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $130
801065d1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801065d6:	e9 44 f5 ff ff       	jmp    80105b1f <alltraps>

801065db <vector131>:
.globl vector131
vector131:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $131
801065dd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801065e2:	e9 38 f5 ff ff       	jmp    80105b1f <alltraps>

801065e7 <vector132>:
.globl vector132
vector132:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $132
801065e9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801065ee:	e9 2c f5 ff ff       	jmp    80105b1f <alltraps>

801065f3 <vector133>:
.globl vector133
vector133:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $133
801065f5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801065fa:	e9 20 f5 ff ff       	jmp    80105b1f <alltraps>

801065ff <vector134>:
.globl vector134
vector134:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $134
80106601:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106606:	e9 14 f5 ff ff       	jmp    80105b1f <alltraps>

8010660b <vector135>:
.globl vector135
vector135:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $135
8010660d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106612:	e9 08 f5 ff ff       	jmp    80105b1f <alltraps>

80106617 <vector136>:
.globl vector136
vector136:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $136
80106619:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010661e:	e9 fc f4 ff ff       	jmp    80105b1f <alltraps>

80106623 <vector137>:
.globl vector137
vector137:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $137
80106625:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010662a:	e9 f0 f4 ff ff       	jmp    80105b1f <alltraps>

8010662f <vector138>:
.globl vector138
vector138:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $138
80106631:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106636:	e9 e4 f4 ff ff       	jmp    80105b1f <alltraps>

8010663b <vector139>:
.globl vector139
vector139:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $139
8010663d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106642:	e9 d8 f4 ff ff       	jmp    80105b1f <alltraps>

80106647 <vector140>:
.globl vector140
vector140:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $140
80106649:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010664e:	e9 cc f4 ff ff       	jmp    80105b1f <alltraps>

80106653 <vector141>:
.globl vector141
vector141:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $141
80106655:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010665a:	e9 c0 f4 ff ff       	jmp    80105b1f <alltraps>

8010665f <vector142>:
.globl vector142
vector142:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $142
80106661:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106666:	e9 b4 f4 ff ff       	jmp    80105b1f <alltraps>

8010666b <vector143>:
.globl vector143
vector143:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $143
8010666d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106672:	e9 a8 f4 ff ff       	jmp    80105b1f <alltraps>

80106677 <vector144>:
.globl vector144
vector144:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $144
80106679:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010667e:	e9 9c f4 ff ff       	jmp    80105b1f <alltraps>

80106683 <vector145>:
.globl vector145
vector145:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $145
80106685:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010668a:	e9 90 f4 ff ff       	jmp    80105b1f <alltraps>

8010668f <vector146>:
.globl vector146
vector146:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $146
80106691:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106696:	e9 84 f4 ff ff       	jmp    80105b1f <alltraps>

8010669b <vector147>:
.globl vector147
vector147:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $147
8010669d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801066a2:	e9 78 f4 ff ff       	jmp    80105b1f <alltraps>

801066a7 <vector148>:
.globl vector148
vector148:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $148
801066a9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801066ae:	e9 6c f4 ff ff       	jmp    80105b1f <alltraps>

801066b3 <vector149>:
.globl vector149
vector149:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $149
801066b5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801066ba:	e9 60 f4 ff ff       	jmp    80105b1f <alltraps>

801066bf <vector150>:
.globl vector150
vector150:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $150
801066c1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801066c6:	e9 54 f4 ff ff       	jmp    80105b1f <alltraps>

801066cb <vector151>:
.globl vector151
vector151:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $151
801066cd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801066d2:	e9 48 f4 ff ff       	jmp    80105b1f <alltraps>

801066d7 <vector152>:
.globl vector152
vector152:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $152
801066d9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801066de:	e9 3c f4 ff ff       	jmp    80105b1f <alltraps>

801066e3 <vector153>:
.globl vector153
vector153:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $153
801066e5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801066ea:	e9 30 f4 ff ff       	jmp    80105b1f <alltraps>

801066ef <vector154>:
.globl vector154
vector154:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $154
801066f1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801066f6:	e9 24 f4 ff ff       	jmp    80105b1f <alltraps>

801066fb <vector155>:
.globl vector155
vector155:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $155
801066fd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106702:	e9 18 f4 ff ff       	jmp    80105b1f <alltraps>

80106707 <vector156>:
.globl vector156
vector156:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $156
80106709:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010670e:	e9 0c f4 ff ff       	jmp    80105b1f <alltraps>

80106713 <vector157>:
.globl vector157
vector157:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $157
80106715:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010671a:	e9 00 f4 ff ff       	jmp    80105b1f <alltraps>

8010671f <vector158>:
.globl vector158
vector158:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $158
80106721:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106726:	e9 f4 f3 ff ff       	jmp    80105b1f <alltraps>

8010672b <vector159>:
.globl vector159
vector159:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $159
8010672d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106732:	e9 e8 f3 ff ff       	jmp    80105b1f <alltraps>

80106737 <vector160>:
.globl vector160
vector160:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $160
80106739:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010673e:	e9 dc f3 ff ff       	jmp    80105b1f <alltraps>

80106743 <vector161>:
.globl vector161
vector161:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $161
80106745:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010674a:	e9 d0 f3 ff ff       	jmp    80105b1f <alltraps>

8010674f <vector162>:
.globl vector162
vector162:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $162
80106751:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106756:	e9 c4 f3 ff ff       	jmp    80105b1f <alltraps>

8010675b <vector163>:
.globl vector163
vector163:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $163
8010675d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106762:	e9 b8 f3 ff ff       	jmp    80105b1f <alltraps>

80106767 <vector164>:
.globl vector164
vector164:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $164
80106769:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010676e:	e9 ac f3 ff ff       	jmp    80105b1f <alltraps>

80106773 <vector165>:
.globl vector165
vector165:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $165
80106775:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010677a:	e9 a0 f3 ff ff       	jmp    80105b1f <alltraps>

8010677f <vector166>:
.globl vector166
vector166:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $166
80106781:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106786:	e9 94 f3 ff ff       	jmp    80105b1f <alltraps>

8010678b <vector167>:
.globl vector167
vector167:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $167
8010678d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106792:	e9 88 f3 ff ff       	jmp    80105b1f <alltraps>

80106797 <vector168>:
.globl vector168
vector168:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $168
80106799:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010679e:	e9 7c f3 ff ff       	jmp    80105b1f <alltraps>

801067a3 <vector169>:
.globl vector169
vector169:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $169
801067a5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801067aa:	e9 70 f3 ff ff       	jmp    80105b1f <alltraps>

801067af <vector170>:
.globl vector170
vector170:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $170
801067b1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801067b6:	e9 64 f3 ff ff       	jmp    80105b1f <alltraps>

801067bb <vector171>:
.globl vector171
vector171:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $171
801067bd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801067c2:	e9 58 f3 ff ff       	jmp    80105b1f <alltraps>

801067c7 <vector172>:
.globl vector172
vector172:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $172
801067c9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801067ce:	e9 4c f3 ff ff       	jmp    80105b1f <alltraps>

801067d3 <vector173>:
.globl vector173
vector173:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $173
801067d5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801067da:	e9 40 f3 ff ff       	jmp    80105b1f <alltraps>

801067df <vector174>:
.globl vector174
vector174:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $174
801067e1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801067e6:	e9 34 f3 ff ff       	jmp    80105b1f <alltraps>

801067eb <vector175>:
.globl vector175
vector175:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $175
801067ed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801067f2:	e9 28 f3 ff ff       	jmp    80105b1f <alltraps>

801067f7 <vector176>:
.globl vector176
vector176:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $176
801067f9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801067fe:	e9 1c f3 ff ff       	jmp    80105b1f <alltraps>

80106803 <vector177>:
.globl vector177
vector177:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $177
80106805:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010680a:	e9 10 f3 ff ff       	jmp    80105b1f <alltraps>

8010680f <vector178>:
.globl vector178
vector178:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $178
80106811:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106816:	e9 04 f3 ff ff       	jmp    80105b1f <alltraps>

8010681b <vector179>:
.globl vector179
vector179:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $179
8010681d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106822:	e9 f8 f2 ff ff       	jmp    80105b1f <alltraps>

80106827 <vector180>:
.globl vector180
vector180:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $180
80106829:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010682e:	e9 ec f2 ff ff       	jmp    80105b1f <alltraps>

80106833 <vector181>:
.globl vector181
vector181:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $181
80106835:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010683a:	e9 e0 f2 ff ff       	jmp    80105b1f <alltraps>

8010683f <vector182>:
.globl vector182
vector182:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $182
80106841:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106846:	e9 d4 f2 ff ff       	jmp    80105b1f <alltraps>

8010684b <vector183>:
.globl vector183
vector183:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $183
8010684d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106852:	e9 c8 f2 ff ff       	jmp    80105b1f <alltraps>

80106857 <vector184>:
.globl vector184
vector184:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $184
80106859:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010685e:	e9 bc f2 ff ff       	jmp    80105b1f <alltraps>

80106863 <vector185>:
.globl vector185
vector185:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $185
80106865:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010686a:	e9 b0 f2 ff ff       	jmp    80105b1f <alltraps>

8010686f <vector186>:
.globl vector186
vector186:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $186
80106871:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106876:	e9 a4 f2 ff ff       	jmp    80105b1f <alltraps>

8010687b <vector187>:
.globl vector187
vector187:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $187
8010687d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106882:	e9 98 f2 ff ff       	jmp    80105b1f <alltraps>

80106887 <vector188>:
.globl vector188
vector188:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $188
80106889:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010688e:	e9 8c f2 ff ff       	jmp    80105b1f <alltraps>

80106893 <vector189>:
.globl vector189
vector189:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $189
80106895:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010689a:	e9 80 f2 ff ff       	jmp    80105b1f <alltraps>

8010689f <vector190>:
.globl vector190
vector190:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $190
801068a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801068a6:	e9 74 f2 ff ff       	jmp    80105b1f <alltraps>

801068ab <vector191>:
.globl vector191
vector191:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $191
801068ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801068b2:	e9 68 f2 ff ff       	jmp    80105b1f <alltraps>

801068b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $192
801068b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801068be:	e9 5c f2 ff ff       	jmp    80105b1f <alltraps>

801068c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $193
801068c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801068ca:	e9 50 f2 ff ff       	jmp    80105b1f <alltraps>

801068cf <vector194>:
.globl vector194
vector194:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $194
801068d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801068d6:	e9 44 f2 ff ff       	jmp    80105b1f <alltraps>

801068db <vector195>:
.globl vector195
vector195:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $195
801068dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801068e2:	e9 38 f2 ff ff       	jmp    80105b1f <alltraps>

801068e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $196
801068e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801068ee:	e9 2c f2 ff ff       	jmp    80105b1f <alltraps>

801068f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $197
801068f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801068fa:	e9 20 f2 ff ff       	jmp    80105b1f <alltraps>

801068ff <vector198>:
.globl vector198
vector198:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $198
80106901:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106906:	e9 14 f2 ff ff       	jmp    80105b1f <alltraps>

8010690b <vector199>:
.globl vector199
vector199:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $199
8010690d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106912:	e9 08 f2 ff ff       	jmp    80105b1f <alltraps>

80106917 <vector200>:
.globl vector200
vector200:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $200
80106919:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010691e:	e9 fc f1 ff ff       	jmp    80105b1f <alltraps>

80106923 <vector201>:
.globl vector201
vector201:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $201
80106925:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010692a:	e9 f0 f1 ff ff       	jmp    80105b1f <alltraps>

8010692f <vector202>:
.globl vector202
vector202:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $202
80106931:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106936:	e9 e4 f1 ff ff       	jmp    80105b1f <alltraps>

8010693b <vector203>:
.globl vector203
vector203:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $203
8010693d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106942:	e9 d8 f1 ff ff       	jmp    80105b1f <alltraps>

80106947 <vector204>:
.globl vector204
vector204:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $204
80106949:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010694e:	e9 cc f1 ff ff       	jmp    80105b1f <alltraps>

80106953 <vector205>:
.globl vector205
vector205:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $205
80106955:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010695a:	e9 c0 f1 ff ff       	jmp    80105b1f <alltraps>

8010695f <vector206>:
.globl vector206
vector206:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $206
80106961:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106966:	e9 b4 f1 ff ff       	jmp    80105b1f <alltraps>

8010696b <vector207>:
.globl vector207
vector207:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $207
8010696d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106972:	e9 a8 f1 ff ff       	jmp    80105b1f <alltraps>

80106977 <vector208>:
.globl vector208
vector208:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $208
80106979:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010697e:	e9 9c f1 ff ff       	jmp    80105b1f <alltraps>

80106983 <vector209>:
.globl vector209
vector209:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $209
80106985:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010698a:	e9 90 f1 ff ff       	jmp    80105b1f <alltraps>

8010698f <vector210>:
.globl vector210
vector210:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $210
80106991:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106996:	e9 84 f1 ff ff       	jmp    80105b1f <alltraps>

8010699b <vector211>:
.globl vector211
vector211:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $211
8010699d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801069a2:	e9 78 f1 ff ff       	jmp    80105b1f <alltraps>

801069a7 <vector212>:
.globl vector212
vector212:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $212
801069a9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801069ae:	e9 6c f1 ff ff       	jmp    80105b1f <alltraps>

801069b3 <vector213>:
.globl vector213
vector213:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $213
801069b5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801069ba:	e9 60 f1 ff ff       	jmp    80105b1f <alltraps>

801069bf <vector214>:
.globl vector214
vector214:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $214
801069c1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801069c6:	e9 54 f1 ff ff       	jmp    80105b1f <alltraps>

801069cb <vector215>:
.globl vector215
vector215:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $215
801069cd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801069d2:	e9 48 f1 ff ff       	jmp    80105b1f <alltraps>

801069d7 <vector216>:
.globl vector216
vector216:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $216
801069d9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801069de:	e9 3c f1 ff ff       	jmp    80105b1f <alltraps>

801069e3 <vector217>:
.globl vector217
vector217:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $217
801069e5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801069ea:	e9 30 f1 ff ff       	jmp    80105b1f <alltraps>

801069ef <vector218>:
.globl vector218
vector218:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $218
801069f1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801069f6:	e9 24 f1 ff ff       	jmp    80105b1f <alltraps>

801069fb <vector219>:
.globl vector219
vector219:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $219
801069fd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a02:	e9 18 f1 ff ff       	jmp    80105b1f <alltraps>

80106a07 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $220
80106a09:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a0e:	e9 0c f1 ff ff       	jmp    80105b1f <alltraps>

80106a13 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $221
80106a15:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a1a:	e9 00 f1 ff ff       	jmp    80105b1f <alltraps>

80106a1f <vector222>:
.globl vector222
vector222:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $222
80106a21:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a26:	e9 f4 f0 ff ff       	jmp    80105b1f <alltraps>

80106a2b <vector223>:
.globl vector223
vector223:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $223
80106a2d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a32:	e9 e8 f0 ff ff       	jmp    80105b1f <alltraps>

80106a37 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $224
80106a39:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a3e:	e9 dc f0 ff ff       	jmp    80105b1f <alltraps>

80106a43 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $225
80106a45:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a4a:	e9 d0 f0 ff ff       	jmp    80105b1f <alltraps>

80106a4f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $226
80106a51:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a56:	e9 c4 f0 ff ff       	jmp    80105b1f <alltraps>

80106a5b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $227
80106a5d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a62:	e9 b8 f0 ff ff       	jmp    80105b1f <alltraps>

80106a67 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $228
80106a69:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a6e:	e9 ac f0 ff ff       	jmp    80105b1f <alltraps>

80106a73 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $229
80106a75:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a7a:	e9 a0 f0 ff ff       	jmp    80105b1f <alltraps>

80106a7f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $230
80106a81:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a86:	e9 94 f0 ff ff       	jmp    80105b1f <alltraps>

80106a8b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $231
80106a8d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a92:	e9 88 f0 ff ff       	jmp    80105b1f <alltraps>

80106a97 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $232
80106a99:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a9e:	e9 7c f0 ff ff       	jmp    80105b1f <alltraps>

80106aa3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $233
80106aa5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106aaa:	e9 70 f0 ff ff       	jmp    80105b1f <alltraps>

80106aaf <vector234>:
.globl vector234
vector234:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $234
80106ab1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ab6:	e9 64 f0 ff ff       	jmp    80105b1f <alltraps>

80106abb <vector235>:
.globl vector235
vector235:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $235
80106abd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ac2:	e9 58 f0 ff ff       	jmp    80105b1f <alltraps>

80106ac7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $236
80106ac9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106ace:	e9 4c f0 ff ff       	jmp    80105b1f <alltraps>

80106ad3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $237
80106ad5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106ada:	e9 40 f0 ff ff       	jmp    80105b1f <alltraps>

80106adf <vector238>:
.globl vector238
vector238:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $238
80106ae1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106ae6:	e9 34 f0 ff ff       	jmp    80105b1f <alltraps>

80106aeb <vector239>:
.globl vector239
vector239:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $239
80106aed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106af2:	e9 28 f0 ff ff       	jmp    80105b1f <alltraps>

80106af7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $240
80106af9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106afe:	e9 1c f0 ff ff       	jmp    80105b1f <alltraps>

80106b03 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $241
80106b05:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b0a:	e9 10 f0 ff ff       	jmp    80105b1f <alltraps>

80106b0f <vector242>:
.globl vector242
vector242:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $242
80106b11:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b16:	e9 04 f0 ff ff       	jmp    80105b1f <alltraps>

80106b1b <vector243>:
.globl vector243
vector243:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $243
80106b1d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b22:	e9 f8 ef ff ff       	jmp    80105b1f <alltraps>

80106b27 <vector244>:
.globl vector244
vector244:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $244
80106b29:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b2e:	e9 ec ef ff ff       	jmp    80105b1f <alltraps>

80106b33 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $245
80106b35:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b3a:	e9 e0 ef ff ff       	jmp    80105b1f <alltraps>

80106b3f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $246
80106b41:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b46:	e9 d4 ef ff ff       	jmp    80105b1f <alltraps>

80106b4b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $247
80106b4d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b52:	e9 c8 ef ff ff       	jmp    80105b1f <alltraps>

80106b57 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $248
80106b59:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b5e:	e9 bc ef ff ff       	jmp    80105b1f <alltraps>

80106b63 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $249
80106b65:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b6a:	e9 b0 ef ff ff       	jmp    80105b1f <alltraps>

80106b6f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $250
80106b71:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b76:	e9 a4 ef ff ff       	jmp    80105b1f <alltraps>

80106b7b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $251
80106b7d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b82:	e9 98 ef ff ff       	jmp    80105b1f <alltraps>

80106b87 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $252
80106b89:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b8e:	e9 8c ef ff ff       	jmp    80105b1f <alltraps>

80106b93 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $253
80106b95:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b9a:	e9 80 ef ff ff       	jmp    80105b1f <alltraps>

80106b9f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $254
80106ba1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ba6:	e9 74 ef ff ff       	jmp    80105b1f <alltraps>

80106bab <vector255>:
.globl vector255
vector255:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $255
80106bad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106bb2:	e9 68 ef ff ff       	jmp    80105b1f <alltraps>
80106bb7:	66 90                	xchg   %ax,%ax
80106bb9:	66 90                	xchg   %ax,%ax
80106bbb:	66 90                	xchg   %ax,%ax
80106bbd:	66 90                	xchg   %ax,%ax
80106bbf:	90                   	nop

80106bc0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	57                   	push   %edi
80106bc4:	89 c7                	mov    %eax,%edi
80106bc6:	56                   	push   %esi
80106bc7:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106bc8:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106bce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bd4:	83 ec 1c             	sub    $0x1c,%esp
80106bd7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106bda:	39 d3                	cmp    %edx,%ebx
80106bdc:	73 55                	jae    80106c33 <deallocuvm.part.0+0x73>
80106bde:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106be1:	eb 12                	jmp    80106bf5 <deallocuvm.part.0+0x35>
80106be3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106be7:	90                   	nop
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106be8:	83 c0 01             	add    $0x1,%eax
80106beb:	c1 e0 16             	shl    $0x16,%eax
80106bee:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106bf0:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80106bf3:	76 3e                	jbe    80106c33 <deallocuvm.part.0+0x73>
  pde = &pgdir[PDX(va)];
80106bf5:	89 d8                	mov    %ebx,%eax
80106bf7:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106bfa:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106bfd:	f6 c1 01             	test   $0x1,%cl
80106c00:	74 e6                	je     80106be8 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106c02:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c04:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106c0a:	c1 ee 0a             	shr    $0xa,%esi
80106c0d:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106c13:	8d 8c 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%ecx
    if(!pte)
80106c1a:	85 c9                	test   %ecx,%ecx
80106c1c:	74 ca                	je     80106be8 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106c1e:	8b 31                	mov    (%ecx),%esi
80106c20:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106c26:	75 18                	jne    80106c40 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106c28:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c2e:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80106c31:	77 c2                	ja     80106bf5 <deallocuvm.part.0+0x35>
        *pte = 0;
      }
    }
  }
  return newsz;
}
80106c33:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106c36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c39:	5b                   	pop    %ebx
80106c3a:	5e                   	pop    %esi
80106c3b:	5f                   	pop    %edi
80106c3c:	5d                   	pop    %ebp
80106c3d:	c3                   	ret    
80106c3e:	66 90                	xchg   %ax,%ax
      if(pa == 0)
80106c40:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106c46:	74 41                	je     80106c89 <deallocuvm.part.0+0xc9>
      decrement_ref_count(pa);
80106c48:	83 ec 0c             	sub    $0xc,%esp
80106c4b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106c4e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      decrement_ref_count(pa);
80106c54:	56                   	push   %esi
80106c55:	e8 06 bb ff ff       	call   80102760 <decrement_ref_count>
      if(get_ref_count(pa) == 0){
80106c5a:	89 34 24             	mov    %esi,(%esp)
80106c5d:	e8 8e ba ff ff       	call   801026f0 <get_ref_count>
80106c62:	83 c4 10             	add    $0x10,%esp
80106c65:	85 c0                	test   %eax,%eax
80106c67:	75 87                	jne    80106bf0 <deallocuvm.part.0+0x30>
      kfree(v);
80106c69:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c6c:	81 c6 00 00 00 80    	add    $0x80000000,%esi
      kfree(v);
80106c72:	56                   	push   %esi
80106c73:	e8 48 b8 ff ff       	call   801024c0 <kfree>
        *pte = 0;
80106c78:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106c7b:	83 c4 10             	add    $0x10,%esp
80106c7e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
80106c84:	e9 67 ff ff ff       	jmp    80106bf0 <deallocuvm.part.0+0x30>
        panic("kfree");
80106c89:	83 ec 0c             	sub    $0xc,%esp
80106c8c:	68 26 7a 10 80       	push   $0x80107a26
80106c91:	e8 ea 96 ff ff       	call   80100380 <panic>
80106c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c9d:	8d 76 00             	lea    0x0(%esi),%esi

80106ca0 <mappages>:
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	57                   	push   %edi
80106ca4:	56                   	push   %esi
80106ca5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106ca6:	89 d3                	mov    %edx,%ebx
80106ca8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106cae:	83 ec 1c             	sub    $0x1c,%esp
80106cb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106cb4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106cb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cbd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106cc0:	8b 45 08             	mov    0x8(%ebp),%eax
80106cc3:	29 d8                	sub    %ebx,%eax
80106cc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106cc8:	eb 3d                	jmp    80106d07 <mappages+0x67>
80106cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106cd0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cd2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106cd7:	c1 ea 0a             	shr    $0xa,%edx
80106cda:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ce0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ce7:	85 c0                	test   %eax,%eax
80106ce9:	74 75                	je     80106d60 <mappages+0xc0>
    if(*pte & PTE_P)
80106ceb:	f6 00 01             	testb  $0x1,(%eax)
80106cee:	0f 85 86 00 00 00    	jne    80106d7a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106cf4:	0b 75 0c             	or     0xc(%ebp),%esi
80106cf7:	83 ce 01             	or     $0x1,%esi
80106cfa:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106cfc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106cff:	74 6f                	je     80106d70 <mappages+0xd0>
    a += PGSIZE;
80106d01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106d07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106d0a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d0d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106d10:	89 d8                	mov    %ebx,%eax
80106d12:	c1 e8 16             	shr    $0x16,%eax
80106d15:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106d18:	8b 07                	mov    (%edi),%eax
80106d1a:	a8 01                	test   $0x1,%al
80106d1c:	75 b2                	jne    80106cd0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d1e:	e8 5d b9 ff ff       	call   80102680 <kalloc>
80106d23:	85 c0                	test   %eax,%eax
80106d25:	74 39                	je     80106d60 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106d27:	83 ec 04             	sub    $0x4,%esp
80106d2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106d2d:	68 00 10 00 00       	push   $0x1000
80106d32:	6a 00                	push   $0x0
80106d34:	50                   	push   %eax
80106d35:	e8 06 db ff ff       	call   80104840 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d3a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106d3d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d40:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106d46:	83 c8 07             	or     $0x7,%eax
80106d49:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106d4b:	89 d8                	mov    %ebx,%eax
80106d4d:	c1 e8 0a             	shr    $0xa,%eax
80106d50:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d55:	01 d0                	add    %edx,%eax
80106d57:	eb 92                	jmp    80106ceb <mappages+0x4b>
80106d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d68:	5b                   	pop    %ebx
80106d69:	5e                   	pop    %esi
80106d6a:	5f                   	pop    %edi
80106d6b:	5d                   	pop    %ebp
80106d6c:	c3                   	ret    
80106d6d:	8d 76 00             	lea    0x0(%esi),%esi
80106d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d73:	31 c0                	xor    %eax,%eax
}
80106d75:	5b                   	pop    %ebx
80106d76:	5e                   	pop    %esi
80106d77:	5f                   	pop    %edi
80106d78:	5d                   	pop    %ebp
80106d79:	c3                   	ret    
      panic("remap");
80106d7a:	83 ec 0c             	sub    $0xc,%esp
80106d7d:	68 04 81 10 80       	push   $0x80108104
80106d82:	e8 f9 95 ff ff       	call   80100380 <panic>
80106d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d8e:	66 90                	xchg   %ax,%ax

80106d90 <seginit>:
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d96:	e8 75 cc ff ff       	call   80103a10 <cpuid>
  pd[0] = size-1;
80106d9b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106da0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106da6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106daa:	c7 80 18 a8 14 80 ff 	movl   $0xffff,-0x7feb57e8(%eax)
80106db1:	ff 00 00 
80106db4:	c7 80 1c a8 14 80 00 	movl   $0xcf9a00,-0x7feb57e4(%eax)
80106dbb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106dbe:	c7 80 20 a8 14 80 ff 	movl   $0xffff,-0x7feb57e0(%eax)
80106dc5:	ff 00 00 
80106dc8:	c7 80 24 a8 14 80 00 	movl   $0xcf9200,-0x7feb57dc(%eax)
80106dcf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106dd2:	c7 80 28 a8 14 80 ff 	movl   $0xffff,-0x7feb57d8(%eax)
80106dd9:	ff 00 00 
80106ddc:	c7 80 2c a8 14 80 00 	movl   $0xcffa00,-0x7feb57d4(%eax)
80106de3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106de6:	c7 80 30 a8 14 80 ff 	movl   $0xffff,-0x7feb57d0(%eax)
80106ded:	ff 00 00 
80106df0:	c7 80 34 a8 14 80 00 	movl   $0xcff200,-0x7feb57cc(%eax)
80106df7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106dfa:	05 10 a8 14 80       	add    $0x8014a810,%eax
  pd[1] = (uint)p;
80106dff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106e03:	c1 e8 10             	shr    $0x10,%eax
80106e06:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106e0a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106e0d:	0f 01 10             	lgdtl  (%eax)
}
80106e10:	c9                   	leave  
80106e11:	c3                   	ret    
80106e12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e20 <walkpgdir>:
{
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	57                   	push   %edi
80106e24:	56                   	push   %esi
80106e25:	53                   	push   %ebx
80106e26:	83 ec 0c             	sub    $0xc,%esp
80106e29:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde = &pgdir[PDX(va)];
80106e2c:	8b 55 08             	mov    0x8(%ebp),%edx
80106e2f:	89 fe                	mov    %edi,%esi
80106e31:	c1 ee 16             	shr    $0x16,%esi
80106e34:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
80106e37:	8b 1e                	mov    (%esi),%ebx
80106e39:	f6 c3 01             	test   $0x1,%bl
80106e3c:	74 22                	je     80106e60 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e3e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106e44:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  return &pgtab[PTX(va)];
80106e4a:	89 f8                	mov    %edi,%eax
}
80106e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106e4f:	c1 e8 0a             	shr    $0xa,%eax
80106e52:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e57:	01 d8                	add    %ebx,%eax
}
80106e59:	5b                   	pop    %ebx
80106e5a:	5e                   	pop    %esi
80106e5b:	5f                   	pop    %edi
80106e5c:	5d                   	pop    %ebp
80106e5d:	c3                   	ret    
80106e5e:	66 90                	xchg   %ax,%ax
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e60:	8b 45 10             	mov    0x10(%ebp),%eax
80106e63:	85 c0                	test   %eax,%eax
80106e65:	74 31                	je     80106e98 <walkpgdir+0x78>
80106e67:	e8 14 b8 ff ff       	call   80102680 <kalloc>
80106e6c:	89 c3                	mov    %eax,%ebx
80106e6e:	85 c0                	test   %eax,%eax
80106e70:	74 26                	je     80106e98 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
80106e72:	83 ec 04             	sub    $0x4,%esp
80106e75:	68 00 10 00 00       	push   $0x1000
80106e7a:	6a 00                	push   $0x0
80106e7c:	50                   	push   %eax
80106e7d:	e8 be d9 ff ff       	call   80104840 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e82:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e88:	83 c4 10             	add    $0x10,%esp
80106e8b:	83 c8 07             	or     $0x7,%eax
80106e8e:	89 06                	mov    %eax,(%esi)
80106e90:	eb b8                	jmp    80106e4a <walkpgdir+0x2a>
80106e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80106e98:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106e9b:	31 c0                	xor    %eax,%eax
}
80106e9d:	5b                   	pop    %ebx
80106e9e:	5e                   	pop    %esi
80106e9f:	5f                   	pop    %edi
80106ea0:	5d                   	pop    %ebp
80106ea1:	c3                   	ret    
80106ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106eb0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106eb0:	a1 c4 d4 14 80       	mov    0x8014d4c4,%eax
80106eb5:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106eba:	0f 22 d8             	mov    %eax,%cr3
}
80106ebd:	c3                   	ret    
80106ebe:	66 90                	xchg   %ax,%ax

80106ec0 <switchuvm>:
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
80106ec6:	83 ec 1c             	sub    $0x1c,%esp
80106ec9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106ecc:	85 f6                	test   %esi,%esi
80106ece:	0f 84 cb 00 00 00    	je     80106f9f <switchuvm+0xdf>
  if(p->kstack == 0)
80106ed4:	8b 46 08             	mov    0x8(%esi),%eax
80106ed7:	85 c0                	test   %eax,%eax
80106ed9:	0f 84 da 00 00 00    	je     80106fb9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106edf:	8b 46 04             	mov    0x4(%esi),%eax
80106ee2:	85 c0                	test   %eax,%eax
80106ee4:	0f 84 c2 00 00 00    	je     80106fac <switchuvm+0xec>
  pushcli();
80106eea:	e8 41 d7 ff ff       	call   80104630 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106eef:	e8 bc ca ff ff       	call   801039b0 <mycpu>
80106ef4:	89 c3                	mov    %eax,%ebx
80106ef6:	e8 b5 ca ff ff       	call   801039b0 <mycpu>
80106efb:	89 c7                	mov    %eax,%edi
80106efd:	e8 ae ca ff ff       	call   801039b0 <mycpu>
80106f02:	83 c7 08             	add    $0x8,%edi
80106f05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f08:	e8 a3 ca ff ff       	call   801039b0 <mycpu>
80106f0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f10:	ba 67 00 00 00       	mov    $0x67,%edx
80106f15:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f1c:	83 c0 08             	add    $0x8,%eax
80106f1f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f26:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f2b:	83 c1 08             	add    $0x8,%ecx
80106f2e:	c1 e8 18             	shr    $0x18,%eax
80106f31:	c1 e9 10             	shr    $0x10,%ecx
80106f34:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f3a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106f40:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f45:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f4c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106f51:	e8 5a ca ff ff       	call   801039b0 <mycpu>
80106f56:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f5d:	e8 4e ca ff ff       	call   801039b0 <mycpu>
80106f62:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f66:	8b 5e 08             	mov    0x8(%esi),%ebx
80106f69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f6f:	e8 3c ca ff ff       	call   801039b0 <mycpu>
80106f74:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f77:	e8 34 ca ff ff       	call   801039b0 <mycpu>
80106f7c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106f80:	b8 28 00 00 00       	mov    $0x28,%eax
80106f85:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106f88:	8b 46 04             	mov    0x4(%esi),%eax
80106f8b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f90:	0f 22 d8             	mov    %eax,%cr3
}
80106f93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f96:	5b                   	pop    %ebx
80106f97:	5e                   	pop    %esi
80106f98:	5f                   	pop    %edi
80106f99:	5d                   	pop    %ebp
  popcli();
80106f9a:	e9 e1 d6 ff ff       	jmp    80104680 <popcli>
    panic("switchuvm: no process");
80106f9f:	83 ec 0c             	sub    $0xc,%esp
80106fa2:	68 0a 81 10 80       	push   $0x8010810a
80106fa7:	e8 d4 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106fac:	83 ec 0c             	sub    $0xc,%esp
80106faf:	68 35 81 10 80       	push   $0x80108135
80106fb4:	e8 c7 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106fb9:	83 ec 0c             	sub    $0xc,%esp
80106fbc:	68 20 81 10 80       	push   $0x80108120
80106fc1:	e8 ba 93 ff ff       	call   80100380 <panic>
80106fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fcd:	8d 76 00             	lea    0x0(%esi),%esi

80106fd0 <inituvm>:
{
80106fd0:	55                   	push   %ebp
80106fd1:	89 e5                	mov    %esp,%ebp
80106fd3:	57                   	push   %edi
80106fd4:	56                   	push   %esi
80106fd5:	53                   	push   %ebx
80106fd6:	83 ec 1c             	sub    $0x1c,%esp
80106fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fdc:	8b 75 10             	mov    0x10(%ebp),%esi
80106fdf:	8b 7d 08             	mov    0x8(%ebp),%edi
80106fe2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106fe5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106feb:	77 5a                	ja     80107047 <inituvm+0x77>
  mem = kalloc();
80106fed:	e8 8e b6 ff ff       	call   80102680 <kalloc>
  incr_ref_count(V2P(mem));
80106ff2:	83 ec 0c             	sub    $0xc,%esp
80106ff5:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  mem = kalloc();
80106ffb:	89 c3                	mov    %eax,%ebx
  incr_ref_count(V2P(mem));
80106ffd:	52                   	push   %edx
80106ffe:	89 55 e0             	mov    %edx,-0x20(%ebp)
80107001:	e8 1a b7 ff ff       	call   80102720 <incr_ref_count>
  memset(mem, 0, PGSIZE);
80107006:	83 c4 0c             	add    $0xc,%esp
80107009:	68 00 10 00 00       	push   $0x1000
8010700e:	6a 00                	push   $0x0
80107010:	53                   	push   %ebx
80107011:	e8 2a d8 ff ff       	call   80104840 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107016:	58                   	pop    %eax
80107017:	5a                   	pop    %edx
80107018:	6a 06                	push   $0x6
8010701a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010701d:	89 f8                	mov    %edi,%eax
8010701f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107024:	52                   	push   %edx
80107025:	31 d2                	xor    %edx,%edx
80107027:	e8 74 fc ff ff       	call   80106ca0 <mappages>
  memmove(mem, init, sz);
8010702c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010702f:	89 75 10             	mov    %esi,0x10(%ebp)
80107032:	83 c4 10             	add    $0x10,%esp
80107035:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107038:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010703b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010703e:	5b                   	pop    %ebx
8010703f:	5e                   	pop    %esi
80107040:	5f                   	pop    %edi
80107041:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107042:	e9 99 d8 ff ff       	jmp    801048e0 <memmove>
    panic("inituvm: more than a page");
80107047:	83 ec 0c             	sub    $0xc,%esp
8010704a:	68 49 81 10 80       	push   $0x80108149
8010704f:	e8 2c 93 ff ff       	call   80100380 <panic>
80107054:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010705b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010705f:	90                   	nop

80107060 <loaduvm>:
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	57                   	push   %edi
80107064:	56                   	push   %esi
80107065:	53                   	push   %ebx
80107066:	83 ec 1c             	sub    $0x1c,%esp
80107069:	8b 45 0c             	mov    0xc(%ebp),%eax
8010706c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010706f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107074:	0f 85 bb 00 00 00    	jne    80107135 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010707a:	01 f0                	add    %esi,%eax
8010707c:	89 f3                	mov    %esi,%ebx
8010707e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107081:	8b 45 14             	mov    0x14(%ebp),%eax
80107084:	01 f0                	add    %esi,%eax
80107086:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107089:	85 f6                	test   %esi,%esi
8010708b:	0f 84 87 00 00 00    	je     80107118 <loaduvm+0xb8>
80107091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107098:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010709b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010709e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801070a0:	89 c2                	mov    %eax,%edx
801070a2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801070a5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801070a8:	f6 c2 01             	test   $0x1,%dl
801070ab:	75 13                	jne    801070c0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801070ad:	83 ec 0c             	sub    $0xc,%esp
801070b0:	68 63 81 10 80       	push   $0x80108163
801070b5:	e8 c6 92 ff ff       	call   80100380 <panic>
801070ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801070c0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801070c9:	25 fc 0f 00 00       	and    $0xffc,%eax
801070ce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801070d5:	85 c0                	test   %eax,%eax
801070d7:	74 d4                	je     801070ad <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
801070d9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801070de:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801070e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801070e8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801070ee:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070f1:	29 d9                	sub    %ebx,%ecx
801070f3:	05 00 00 00 80       	add    $0x80000000,%eax
801070f8:	57                   	push   %edi
801070f9:	51                   	push   %ecx
801070fa:	50                   	push   %eax
801070fb:	ff 75 10             	push   0x10(%ebp)
801070fe:	e8 8d a9 ff ff       	call   80101a90 <readi>
80107103:	83 c4 10             	add    $0x10,%esp
80107106:	39 f8                	cmp    %edi,%eax
80107108:	75 1e                	jne    80107128 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010710a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107110:	89 f0                	mov    %esi,%eax
80107112:	29 d8                	sub    %ebx,%eax
80107114:	39 c6                	cmp    %eax,%esi
80107116:	77 80                	ja     80107098 <loaduvm+0x38>
}
80107118:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010711b:	31 c0                	xor    %eax,%eax
}
8010711d:	5b                   	pop    %ebx
8010711e:	5e                   	pop    %esi
8010711f:	5f                   	pop    %edi
80107120:	5d                   	pop    %ebp
80107121:	c3                   	ret    
80107122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107128:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010712b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107130:	5b                   	pop    %ebx
80107131:	5e                   	pop    %esi
80107132:	5f                   	pop    %edi
80107133:	5d                   	pop    %ebp
80107134:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107135:	83 ec 0c             	sub    $0xc,%esp
80107138:	68 04 82 10 80       	push   $0x80108204
8010713d:	e8 3e 92 ff ff       	call   80100380 <panic>
80107142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107150 <allocuvm>:
{
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	57                   	push   %edi
80107154:	56                   	push   %esi
80107155:	53                   	push   %ebx
80107156:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107159:	8b 45 10             	mov    0x10(%ebp),%eax
8010715c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010715f:	85 c0                	test   %eax,%eax
80107161:	0f 88 c9 00 00 00    	js     80107230 <allocuvm+0xe0>
  if(newsz < oldsz)
80107167:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010716a:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
8010716d:	0f 82 ad 00 00 00    	jb     80107220 <allocuvm+0xd0>
  a = PGROUNDUP(oldsz);
80107173:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107179:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
8010717f:	39 75 10             	cmp    %esi,0x10(%ebp)
80107182:	77 46                	ja     801071ca <allocuvm+0x7a>
80107184:	e9 9a 00 00 00       	jmp    80107223 <allocuvm+0xd3>
80107189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107190:	83 ec 04             	sub    $0x4,%esp
80107193:	68 00 10 00 00       	push   $0x1000
80107198:	6a 00                	push   $0x0
8010719a:	53                   	push   %ebx
8010719b:	e8 a0 d6 ff ff       	call   80104840 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801071a0:	58                   	pop    %eax
801071a1:	5a                   	pop    %edx
801071a2:	6a 06                	push   $0x6
801071a4:	57                   	push   %edi
801071a5:	8b 45 08             	mov    0x8(%ebp),%eax
801071a8:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071ad:	89 f2                	mov    %esi,%edx
801071af:	e8 ec fa ff ff       	call   80106ca0 <mappages>
801071b4:	83 c4 10             	add    $0x10,%esp
801071b7:	85 c0                	test   %eax,%eax
801071b9:	0f 88 89 00 00 00    	js     80107248 <allocuvm+0xf8>
  for(; a < newsz; a += PGSIZE){
801071bf:	81 c6 00 10 00 00    	add    $0x1000,%esi
801071c5:	39 75 10             	cmp    %esi,0x10(%ebp)
801071c8:	76 59                	jbe    80107223 <allocuvm+0xd3>
    mem = kalloc();
801071ca:	e8 b1 b4 ff ff       	call   80102680 <kalloc>
    incr_ref_count(V2P(mem));
801071cf:	83 ec 0c             	sub    $0xc,%esp
801071d2:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
    mem = kalloc();
801071d8:	89 c3                	mov    %eax,%ebx
    incr_ref_count(V2P(mem));
801071da:	57                   	push   %edi
801071db:	e8 40 b5 ff ff       	call   80102720 <incr_ref_count>
    if(mem == 0){
801071e0:	83 c4 10             	add    $0x10,%esp
801071e3:	85 db                	test   %ebx,%ebx
801071e5:	75 a9                	jne    80107190 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801071e7:	83 ec 0c             	sub    $0xc,%esp
801071ea:	68 81 81 10 80       	push   $0x80108181
801071ef:	e8 ac 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801071f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801071f7:	83 c4 10             	add    $0x10,%esp
801071fa:	39 45 10             	cmp    %eax,0x10(%ebp)
801071fd:	74 31                	je     80107230 <allocuvm+0xe0>
801071ff:	8b 55 10             	mov    0x10(%ebp),%edx
80107202:	89 c1                	mov    %eax,%ecx
80107204:	8b 45 08             	mov    0x8(%ebp),%eax
80107207:	e8 b4 f9 ff ff       	call   80106bc0 <deallocuvm.part.0>
      return 0;
8010720c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107213:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107216:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107219:	5b                   	pop    %ebx
8010721a:	5e                   	pop    %esi
8010721b:	5f                   	pop    %edi
8010721c:	5d                   	pop    %ebp
8010721d:	c3                   	ret    
8010721e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107220:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107223:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107226:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107229:	5b                   	pop    %ebx
8010722a:	5e                   	pop    %esi
8010722b:	5f                   	pop    %edi
8010722c:	5d                   	pop    %ebp
8010722d:	c3                   	ret    
8010722e:	66 90                	xchg   %ax,%ax
    return 0;
80107230:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107237:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010723a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010723d:	5b                   	pop    %ebx
8010723e:	5e                   	pop    %esi
8010723f:	5f                   	pop    %edi
80107240:	5d                   	pop    %ebp
80107241:	c3                   	ret    
80107242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107248:	83 ec 0c             	sub    $0xc,%esp
8010724b:	68 99 81 10 80       	push   $0x80108199
80107250:	e8 4b 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107255:	8b 45 0c             	mov    0xc(%ebp),%eax
80107258:	83 c4 10             	add    $0x10,%esp
8010725b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010725e:	74 0d                	je     8010726d <allocuvm+0x11d>
80107260:	89 c1                	mov    %eax,%ecx
80107262:	8b 55 10             	mov    0x10(%ebp),%edx
80107265:	8b 45 08             	mov    0x8(%ebp),%eax
80107268:	e8 53 f9 ff ff       	call   80106bc0 <deallocuvm.part.0>
      kfree(mem);
8010726d:	83 ec 0c             	sub    $0xc,%esp
80107270:	53                   	push   %ebx
80107271:	e8 4a b2 ff ff       	call   801024c0 <kfree>
      return 0;
80107276:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010727d:	83 c4 10             	add    $0x10,%esp
}
80107280:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107283:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107286:	5b                   	pop    %ebx
80107287:	5e                   	pop    %esi
80107288:	5f                   	pop    %edi
80107289:	5d                   	pop    %ebp
8010728a:	c3                   	ret    
8010728b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010728f:	90                   	nop

80107290 <deallocuvm>:
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	8b 55 0c             	mov    0xc(%ebp),%edx
80107296:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107299:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010729c:	39 d1                	cmp    %edx,%ecx
8010729e:	73 10                	jae    801072b0 <deallocuvm+0x20>
}
801072a0:	5d                   	pop    %ebp
801072a1:	e9 1a f9 ff ff       	jmp    80106bc0 <deallocuvm.part.0>
801072a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072ad:	8d 76 00             	lea    0x0(%esi),%esi
801072b0:	89 d0                	mov    %edx,%eax
801072b2:	5d                   	pop    %ebp
801072b3:	c3                   	ret    
801072b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072bf:	90                   	nop

801072c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	57                   	push   %edi
801072c4:	56                   	push   %esi
801072c5:	53                   	push   %ebx
801072c6:	83 ec 0c             	sub    $0xc,%esp
801072c9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801072cc:	85 f6                	test   %esi,%esi
801072ce:	74 59                	je     80107329 <freevm+0x69>
  if(newsz >= oldsz)
801072d0:	31 c9                	xor    %ecx,%ecx
801072d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801072d7:	89 f0                	mov    %esi,%eax
801072d9:	89 f3                	mov    %esi,%ebx
801072db:	e8 e0 f8 ff ff       	call   80106bc0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801072e6:	eb 0f                	jmp    801072f7 <freevm+0x37>
801072e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072ef:	90                   	nop
801072f0:	83 c3 04             	add    $0x4,%ebx
801072f3:	39 df                	cmp    %ebx,%edi
801072f5:	74 23                	je     8010731a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801072f7:	8b 03                	mov    (%ebx),%eax
801072f9:	a8 01                	test   $0x1,%al
801072fb:	74 f3                	je     801072f0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107302:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107305:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107308:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010730d:	50                   	push   %eax
8010730e:	e8 ad b1 ff ff       	call   801024c0 <kfree>
80107313:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107316:	39 df                	cmp    %ebx,%edi
80107318:	75 dd                	jne    801072f7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010731a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010731d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107320:	5b                   	pop    %ebx
80107321:	5e                   	pop    %esi
80107322:	5f                   	pop    %edi
80107323:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107324:	e9 97 b1 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107329:	83 ec 0c             	sub    $0xc,%esp
8010732c:	68 b5 81 10 80       	push   $0x801081b5
80107331:	e8 4a 90 ff ff       	call   80100380 <panic>
80107336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010733d:	8d 76 00             	lea    0x0(%esi),%esi

80107340 <setupkvm>:
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	56                   	push   %esi
80107344:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107345:	e8 36 b3 ff ff       	call   80102680 <kalloc>
8010734a:	89 c6                	mov    %eax,%esi
8010734c:	85 c0                	test   %eax,%eax
8010734e:	74 42                	je     80107392 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107350:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107353:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107358:	68 00 10 00 00       	push   $0x1000
8010735d:	6a 00                	push   $0x0
8010735f:	50                   	push   %eax
80107360:	e8 db d4 ff ff       	call   80104840 <memset>
80107365:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107368:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010736b:	83 ec 08             	sub    $0x8,%esp
8010736e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107371:	ff 73 0c             	push   0xc(%ebx)
80107374:	8b 13                	mov    (%ebx),%edx
80107376:	50                   	push   %eax
80107377:	29 c1                	sub    %eax,%ecx
80107379:	89 f0                	mov    %esi,%eax
8010737b:	e8 20 f9 ff ff       	call   80106ca0 <mappages>
80107380:	83 c4 10             	add    $0x10,%esp
80107383:	85 c0                	test   %eax,%eax
80107385:	78 19                	js     801073a0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107387:	83 c3 10             	add    $0x10,%ebx
8010738a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107390:	75 d6                	jne    80107368 <setupkvm+0x28>
}
80107392:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107395:	89 f0                	mov    %esi,%eax
80107397:	5b                   	pop    %ebx
80107398:	5e                   	pop    %esi
80107399:	5d                   	pop    %ebp
8010739a:	c3                   	ret    
8010739b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010739f:	90                   	nop
      freevm(pgdir);
801073a0:	83 ec 0c             	sub    $0xc,%esp
801073a3:	56                   	push   %esi
      return 0;
801073a4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801073a6:	e8 15 ff ff ff       	call   801072c0 <freevm>
      return 0;
801073ab:	83 c4 10             	add    $0x10,%esp
}
801073ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801073b1:	89 f0                	mov    %esi,%eax
801073b3:	5b                   	pop    %ebx
801073b4:	5e                   	pop    %esi
801073b5:	5d                   	pop    %ebp
801073b6:	c3                   	ret    
801073b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073be:	66 90                	xchg   %ax,%ax

801073c0 <kvmalloc>:
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801073c6:	e8 75 ff ff ff       	call   80107340 <setupkvm>
801073cb:	a3 c4 d4 14 80       	mov    %eax,0x8014d4c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073d0:	05 00 00 00 80       	add    $0x80000000,%eax
801073d5:	0f 22 d8             	mov    %eax,%cr3
}
801073d8:	c9                   	leave  
801073d9:	c3                   	ret    
801073da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
801073e3:	83 ec 08             	sub    $0x8,%esp
801073e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801073e9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801073ec:	89 c1                	mov    %eax,%ecx
801073ee:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801073f1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801073f4:	f6 c2 01             	test   $0x1,%dl
801073f7:	75 17                	jne    80107410 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801073f9:	83 ec 0c             	sub    $0xc,%esp
801073fc:	68 c6 81 10 80       	push   $0x801081c6
80107401:	e8 7a 8f ff ff       	call   80100380 <panic>
80107406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010740d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107410:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107413:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107419:	25 fc 0f 00 00       	and    $0xffc,%eax
8010741e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107425:	85 c0                	test   %eax,%eax
80107427:	74 d0                	je     801073f9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107429:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010742c:	c9                   	leave  
8010742d:	c3                   	ret    
8010742e:	66 90                	xchg   %ax,%ax

80107430 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	57                   	push   %edi
80107434:	56                   	push   %esi
80107435:	53                   	push   %ebx
80107436:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107439:	e8 02 ff ff ff       	call   80107340 <setupkvm>
8010743e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107441:	85 c0                	test   %eax,%eax
80107443:	0f 84 bd 00 00 00    	je     80107506 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107449:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010744c:	85 c9                	test   %ecx,%ecx
8010744e:	0f 84 b2 00 00 00    	je     80107506 <copyuvm+0xd6>
80107454:	31 f6                	xor    %esi,%esi
80107456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010745d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107460:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107463:	89 f0                	mov    %esi,%eax
80107465:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107468:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010746b:	a8 01                	test   $0x1,%al
8010746d:	75 11                	jne    80107480 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010746f:	83 ec 0c             	sub    $0xc,%esp
80107472:	68 d0 81 10 80       	push   $0x801081d0
80107477:	e8 04 8f ff ff       	call   80100380 <panic>
8010747c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107480:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107482:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107487:	c1 ea 0a             	shr    $0xa,%edx
8010748a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107490:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107497:	85 c0                	test   %eax,%eax
80107499:	74 d4                	je     8010746f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010749b:	8b 00                	mov    (%eax),%eax
8010749d:	a8 01                	test   $0x1,%al
8010749f:	0f 84 9f 00 00 00    	je     80107544 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801074a5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801074a7:	25 ff 0f 00 00       	and    $0xfff,%eax
801074ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801074af:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801074b5:	e8 c6 b1 ff ff       	call   80102680 <kalloc>
801074ba:	89 c3                	mov    %eax,%ebx
801074bc:	85 c0                	test   %eax,%eax
801074be:	74 64                	je     80107524 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801074c0:	83 ec 04             	sub    $0x4,%esp
801074c3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801074c9:	68 00 10 00 00       	push   $0x1000
801074ce:	57                   	push   %edi
801074cf:	50                   	push   %eax
801074d0:	e8 0b d4 ff ff       	call   801048e0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801074d5:	58                   	pop    %eax
801074d6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074dc:	5a                   	pop    %edx
801074dd:	ff 75 e4             	push   -0x1c(%ebp)
801074e0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074e5:	89 f2                	mov    %esi,%edx
801074e7:	50                   	push   %eax
801074e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074eb:	e8 b0 f7 ff ff       	call   80106ca0 <mappages>
801074f0:	83 c4 10             	add    $0x10,%esp
801074f3:	85 c0                	test   %eax,%eax
801074f5:	78 21                	js     80107518 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801074f7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801074fd:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107500:	0f 87 5a ff ff ff    	ja     80107460 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107506:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107509:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010750c:	5b                   	pop    %ebx
8010750d:	5e                   	pop    %esi
8010750e:	5f                   	pop    %edi
8010750f:	5d                   	pop    %ebp
80107510:	c3                   	ret    
80107511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107518:	83 ec 0c             	sub    $0xc,%esp
8010751b:	53                   	push   %ebx
8010751c:	e8 9f af ff ff       	call   801024c0 <kfree>
      goto bad;
80107521:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107524:	83 ec 0c             	sub    $0xc,%esp
80107527:	ff 75 e0             	push   -0x20(%ebp)
8010752a:	e8 91 fd ff ff       	call   801072c0 <freevm>
  return 0;
8010752f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107536:	83 c4 10             	add    $0x10,%esp
}
80107539:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010753c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010753f:	5b                   	pop    %ebx
80107540:	5e                   	pop    %esi
80107541:	5f                   	pop    %edi
80107542:	5d                   	pop    %ebp
80107543:	c3                   	ret    
      panic("copyuvm: page not present");
80107544:	83 ec 0c             	sub    $0xc,%esp
80107547:	68 ea 81 10 80       	push   $0x801081ea
8010754c:	e8 2f 8e ff ff       	call   80100380 <panic>
80107551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010755f:	90                   	nop

80107560 <copyuvmcow>:

pde_t*
copyuvmcow(pde_t *pgdir, uint sz)
{
80107560:	55                   	push   %ebp
80107561:	89 e5                	mov    %esp,%ebp
80107563:	57                   	push   %edi
80107564:	56                   	push   %esi
80107565:	53                   	push   %ebx
80107566:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
80107569:	e8 d2 fd ff ff       	call   80107340 <setupkvm>
8010756e:	89 c6                	mov    %eax,%esi
80107570:	85 c0                	test   %eax,%eax
80107572:	0f 84 bc 00 00 00    	je     80107634 <copyuvmcow+0xd4>
    return 0;

  for(i = 0; i < sz; i += PGSIZE){
80107578:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010757b:	85 c9                	test   %ecx,%ecx
8010757d:	0f 84 a6 00 00 00    	je     80107629 <copyuvmcow+0xc9>
80107583:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107586:	31 ff                	xor    %edi,%edi
80107588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010758f:	90                   	nop
  if(*pde & PTE_P){
80107590:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107593:	89 f8                	mov    %edi,%eax
80107595:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107598:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010759b:	a8 01                	test   $0x1,%al
8010759d:	75 11                	jne    801075b0 <copyuvmcow+0x50>

    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010759f:	83 ec 0c             	sub    $0xc,%esp
801075a2:	68 d0 81 10 80       	push   $0x801081d0
801075a7:	e8 d4 8d ff ff       	call   80100380 <panic>
801075ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801075b0:	89 fa                	mov    %edi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801075b7:	c1 ea 0a             	shr    $0xa,%edx
801075ba:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801075c0:	8d 94 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edx
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801075c7:	85 d2                	test   %edx,%edx
801075c9:	74 d4                	je     8010759f <copyuvmcow+0x3f>

    if(!(*pte & PTE_P))
801075cb:	8b 1a                	mov    (%edx),%ebx
801075cd:	f6 c3 01             	test   $0x1,%bl
801075d0:	0f 84 90 00 00 00    	je     80107666 <copyuvmcow+0x106>
      panic("copyuvm: page not present");

    pa = PTE_ADDR(*pte);
801075d6:	89 de                	mov    %ebx,%esi

    flags = PTE_FLAGS(*pte);
    incr_ref_count(pa);
801075d8:	83 ec 0c             	sub    $0xc,%esp
801075db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
801075de:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
801075e4:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    incr_ref_count(pa);
801075ea:	56                   	push   %esi
801075eb:	e8 30 b1 ff ff       	call   80102720 <incr_ref_count>
    // Marcar página como READ ONLY e incrementar contador de referências
    *pte &= ~PTE_W;
801075f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    *pte |= PTE_COW;  // Marcar como Copy-on-Write

    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) {
801075f3:	b9 00 10 00 00       	mov    $0x1000,%ecx
    *pte &= ~PTE_W;
801075f8:	8b 02                	mov    (%edx),%eax
801075fa:	83 e0 fd             	and    $0xfffffffd,%eax
    *pte |= PTE_COW;  // Marcar como Copy-on-Write
801075fd:	80 cc 02             	or     $0x2,%ah
80107600:	89 02                	mov    %eax,(%edx)
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) {
80107602:	58                   	pop    %eax
80107603:	5a                   	pop    %edx
80107604:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107607:	53                   	push   %ebx
80107608:	89 fa                	mov    %edi,%edx
8010760a:	56                   	push   %esi
8010760b:	e8 90 f6 ff ff       	call   80106ca0 <mappages>
80107610:	83 c4 10             	add    $0x10,%esp
80107613:	85 c0                	test   %eax,%eax
80107615:	78 29                	js     80107640 <copyuvmcow+0xe0>
  for(i = 0; i < sz; i += PGSIZE){
80107617:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010761d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107620:	0f 87 6a ff ff ff    	ja     80107590 <copyuvmcow+0x30>
80107626:	8b 75 e0             	mov    -0x20(%ebp),%esi
      goto bad;
    }

  }
  
  lcr3(V2P(pgdir));
80107629:	8b 45 08             	mov    0x8(%ebp),%eax
8010762c:	05 00 00 00 80       	add    $0x80000000,%eax
80107631:	0f 22 d8             	mov    %eax,%cr3

bad:
  freevm(d);
  lcr3(V2P(pgdir));
  return 0;
}
80107634:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107637:	89 f0                	mov    %esi,%eax
80107639:	5b                   	pop    %ebx
8010763a:	5e                   	pop    %esi
8010763b:	5f                   	pop    %edi
8010763c:	5d                   	pop    %ebp
8010763d:	c3                   	ret    
8010763e:	66 90                	xchg   %ax,%ax
  freevm(d);
80107640:	8b 75 e0             	mov    -0x20(%ebp),%esi
80107643:	83 ec 0c             	sub    $0xc,%esp
80107646:	56                   	push   %esi
80107647:	e8 74 fc ff ff       	call   801072c0 <freevm>
  lcr3(V2P(pgdir));
8010764c:	8b 45 08             	mov    0x8(%ebp),%eax
8010764f:	05 00 00 00 80       	add    $0x80000000,%eax
80107654:	0f 22 d8             	mov    %eax,%cr3
  return 0;
80107657:	31 f6                	xor    %esi,%esi
80107659:	83 c4 10             	add    $0x10,%esp
}
8010765c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010765f:	5b                   	pop    %ebx
80107660:	89 f0                	mov    %esi,%eax
80107662:	5e                   	pop    %esi
80107663:	5f                   	pop    %edi
80107664:	5d                   	pop    %ebp
80107665:	c3                   	ret    
      panic("copyuvm: page not present");
80107666:	83 ec 0c             	sub    $0xc,%esp
80107669:	68 ea 81 10 80       	push   $0x801081ea
8010766e:	e8 0d 8d ff ff       	call   80100380 <panic>
80107673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010767a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107680 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107680:	55                   	push   %ebp
80107681:	89 e5                	mov    %esp,%ebp
80107683:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107686:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107689:	89 c1                	mov    %eax,%ecx
8010768b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010768e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107691:	f6 c2 01             	test   $0x1,%dl
80107694:	0f 84 00 01 00 00    	je     8010779a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010769a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010769d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801076a3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801076a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801076a9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801076b0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801076b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801076b7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801076ba:	05 00 00 00 80       	add    $0x80000000,%eax
801076bf:	83 fa 05             	cmp    $0x5,%edx
801076c2:	ba 00 00 00 00       	mov    $0x0,%edx
801076c7:	0f 45 c2             	cmovne %edx,%eax
}
801076ca:	c3                   	ret    
801076cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076cf:	90                   	nop

801076d0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801076d0:	55                   	push   %ebp
801076d1:	89 e5                	mov    %esp,%ebp
801076d3:	57                   	push   %edi
801076d4:	56                   	push   %esi
801076d5:	53                   	push   %ebx
801076d6:	83 ec 0c             	sub    $0xc,%esp
801076d9:	8b 75 14             	mov    0x14(%ebp),%esi
801076dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801076df:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801076e2:	85 f6                	test   %esi,%esi
801076e4:	75 51                	jne    80107737 <copyout+0x67>
801076e6:	e9 a5 00 00 00       	jmp    80107790 <copyout+0xc0>
801076eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076ef:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801076f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801076f6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801076fc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107702:	74 75                	je     80107779 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107704:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107706:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107709:	29 c3                	sub    %eax,%ebx
8010770b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107711:	39 f3                	cmp    %esi,%ebx
80107713:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107716:	29 f8                	sub    %edi,%eax
80107718:	83 ec 04             	sub    $0x4,%esp
8010771b:	01 c1                	add    %eax,%ecx
8010771d:	53                   	push   %ebx
8010771e:	52                   	push   %edx
8010771f:	51                   	push   %ecx
80107720:	e8 bb d1 ff ff       	call   801048e0 <memmove>
    len -= n;
    buf += n;
80107725:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107728:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010772e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107731:	01 da                	add    %ebx,%edx
  while(len > 0){
80107733:	29 de                	sub    %ebx,%esi
80107735:	74 59                	je     80107790 <copyout+0xc0>
  if(*pde & PTE_P){
80107737:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010773a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010773c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010773e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107741:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107747:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010774a:	f6 c1 01             	test   $0x1,%cl
8010774d:	0f 84 4e 00 00 00    	je     801077a1 <copyout.cold>
  return &pgtab[PTX(va)];
80107753:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107755:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010775b:	c1 eb 0c             	shr    $0xc,%ebx
8010775e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107764:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010776b:	89 d9                	mov    %ebx,%ecx
8010776d:	83 e1 05             	and    $0x5,%ecx
80107770:	83 f9 05             	cmp    $0x5,%ecx
80107773:	0f 84 77 ff ff ff    	je     801076f0 <copyout+0x20>
  }
  return 0;
}
80107779:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010777c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107781:	5b                   	pop    %ebx
80107782:	5e                   	pop    %esi
80107783:	5f                   	pop    %edi
80107784:	5d                   	pop    %ebp
80107785:	c3                   	ret    
80107786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010778d:	8d 76 00             	lea    0x0(%esi),%esi
80107790:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107793:	31 c0                	xor    %eax,%eax
}
80107795:	5b                   	pop    %ebx
80107796:	5e                   	pop    %esi
80107797:	5f                   	pop    %edi
80107798:	5d                   	pop    %ebp
80107799:	c3                   	ret    

8010779a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010779a:	a1 00 00 00 00       	mov    0x0,%eax
8010779f:	0f 0b                	ud2    

801077a1 <copyout.cold>:
801077a1:	a1 00 00 00 00       	mov    0x0,%eax
801077a6:	0f 0b                	ud2    
