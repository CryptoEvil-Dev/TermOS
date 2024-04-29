#ifndef ELF_H
#define ELF_H

// OFFSET TABLE
// e_ident[16]
#define EI_CLASS        4
#define EI_DATA         5
#define EI_VERSION      6
#define EI_OSABI        7
#define EI_ABIVERSION   8
#define EI_PAD_START    9
#define EI_PAD_END      15

#define e_type          16
#define e_machine       17
#define e_version       18 // Дублирует значение из EI_VERSION
#define e_entry         19 // Сюда нужно провалится

// Values from e_type
#define ET_EXEC         0x02
#define ET_REL          0x01
#define ET_DYN          0x03

// Values from e_machine
#define EM_X86_64       0x42
#define EM_386          0x03
#define EM_ARM          0x28

#endif